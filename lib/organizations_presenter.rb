# encoding: utf-8

module OrganizationsPresenter
  extend ActiveSupport::Concern

  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  module ClassMethods
    include Rails.application.routes.url_helpers
    attr_accessor :kind, :filters

    def acts_as_organizations_presenter(*args)
      options = args.extract_options!

      self.kind = options[:kind].to_s           # e.g kind: :sport
      self.filters = [*options[:filters]]       # e.g filters: [:categories, :features]

      self.filters.map(&:to_s).each do |filter|
        # define methods such as categories_filter, features_filter
        define_method "#{filter}_filter" do
          instance_variable_get("@#{filter}_filter") ||
            instance_variable_set("@#{filter}_filter", Hashie::Mash.new.tap { |h|
            h[:selected] = send(filter) || []
            h[:available] = HasSearcher.searcher(pluralized_kind.to_sym).facet("#{kind}_#{filter.singularize}").rows.map(&:value)
            h['used?'] = send(filter).present? && send(filter).any?
          })
        end
      end
    end
  end

  def kind
    self.class.kind
  end

  def pluralized_kind
    kind.pluralize
  end

  def decorator_class
    "#{self.class.kind}_decorator".classify.constantize
  end

  def collection
    decorator_class.decorate(searcher.results)
  end

  def collection_geo_info
    searcher(1_000).results.map do |organization|
      {
        'title'   => link_to(organization.organization_title, organization.organization),
        'address' => organization.address.to_s,
        'lat'     => organization.latitude,
        'lon'     => organization.longitude
      }
    end.uniq.to_json
  end

  def paginated_collection
    searcher.results
  end

  def total_count
    searcher.total
  end

  def geo_filter
    @geo_filter ||= Hashie::Mash.new.tap { |h|
      h[:lat] = lat
      h[:lon] = lon
      h[:radius] = radius
      h['used?'] = lat.present? && lon.present? && radius.present?
    }
  end

  def searcher_params
    {}.tap do |params|
      self.class.filters.map(&:to_s).map(&:singularize).each do |filter|
        params["#{kind}_#{filter}".to_sym] = send("#{filter.pluralize}_filter").selected if send("#{filter.pluralize}_filter").used?
      end

      params[:location] = Hashie::Mash.new(lat: geo_filter.lat, lon: geo_filter.lon, radius: geo_filter.radius) if geo_filter.used?
    end
  end

  def query
    {}.tap { |hash|
      hash[:utf8] = '✓'

      %w[order_by lat lon radius].each { |p| hash[p] = send(p) }

      self.class.filters.map(&:to_s).each do |filter|
        hash[filter] = send("#{filter}_filter").selected if send("#{filter}_filter").used?
      end
    }
  end

  private

  def searcher(per_page_count = per_page)
    @searcher ||= HasSearcher.searcher(pluralized_kind.to_sym, searcher_params).tap { |s|
      s.paginate(page: page, per_page: per_page_count)
      s.send("order_by_#{order_by}")
    }
  end
end

