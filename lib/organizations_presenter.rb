# encoding: utf-8

module OrganizationsPresenter
  extend ActiveSupport::Concern

  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  attr_accessor :order_by

  included do
    available_sortings.each do |sorting|
      define_method "sort_by_#{sorting}?" do
        order_by == sorting
      end
    end
  end

  module ClassMethods
    include Rails.application.routes.url_helpers
    attr_accessor :kind, :filters

    def suborganization_kinds
      OrganizationsCatalogPresenter.suborganization_models
    end

    def acts_as_organizations_presenter(*args)
      options = args.extract_options!

      self.kind = options[:kind].to_s           # e.g kind: :sport
      self.filters = [*options[:filters]]       # e.g filters: [:categories, :features]

      self.filters.map(&:to_s).each do |filter|
        # define methods such as categories_filter, features_filter
        define_method "#{filter}_filter" do
          instance_variable_get("@#{filter}_filter") ||
            instance_variable_set("@#{filter}_filter", Hashie::Mash.new.tap { |h|
            h[:selected] = (send(filter) || []).delete_if(&:blank?)
            h[:available] = HasSearcher.searcher(pluralized_kind.to_sym).facet("#{kind}_#{filter.singularize}").rows.map(&:value)
            h['used?'] = send(filter).present? && send(filter).any?
          })
        end
      end
    end

    def available_sortings
      %w[rating nearness title]
    end

    def available_sortings_without_nearness
      available_sortings - ['nearness']
    end
  end

  def coupons
    @coupons ||= Coupon.search {
      with :suborganizations_kind, kind
      paginate :page => 1, :per_page => 100
    }.results.sample(3)
  end

  def initialize(args = {})
    super(args)

    @page ||= 1
    @per_page = 18
  end

  def order_by
    @order_by = self.class.available_sortings.include?(@order_by) ? @order_by : self.class.available_sortings.first
    @order_by = self.class.available_sortings_without_nearness.include?(@order_by) ? @order_by : self.class.available_sortings.first unless geo_filter.used?

    @order_by
  end

  def keywords
    [].tap { |keywords|
      keywords.concat(categories_filter.selected) if respond_to?(:categories_filter) && categories_filter.used?
      keywords.concat(features_filter.selected)   if respond_to?(:features_filter)   && features_filter.used?
      keywords.concat(offers_filter.selected)     if respond_to?(:offers_filter)     && offers_filter.used?
      keywords.concat(cuisines_filter.selected)   if respond_to?(:cuisines_filter)   && cuisines_filter.used?

      keywords.concat(categories_filter.available) if keywords.empty?
    }.join(', ')
  end

  def canonical_link
    Settings['app']['url'] + '/' + self.kind.pluralize
  end

  def page_title
    title = ""
    categories_filter.selected.each_with_index do |category, index|
      title << (index == 0 ?  "" : (categories_filter.selected.size.eql?(index+1) ? " и " : ", "))
      title << category
    end
    title.blank? ? I18n.t("meta.#{pluralized_kind}.title") : "#{title.mb_chars.capitalize} Томска"
  end

  def kind
    @kind ||= self.class.kind
  end

  def pluralized_kind
    @pluralized_kind ||= kind.pluralize
  end

  def selected_kind
    @selected_kind ||= kind
  end

  def decorator_class
    "#{self.class.kind}_decorator".classify.constantize
  end

  def collection
    decorator_class.decorate(searcher.results)
  end

  def collection_geo_info
    #searcher(per_page * 3).results.map do |organization|
      #{
        #'title'   => link_to(organization.organization_title, organization.organization),
        #'address' => organization.address.to_s,
        #'lat'     => organization.latitude,
        #'lon'     => organization.longitude
      #}
    #end.uniq.to_json
    {}
  end

  def paginated_collection
    searcher.results
  end

  def selected_category
    @selected_category ||= "".tap do |str|
      str << (categories_filter[:selected].first || pluralized_kind)
      str.replace FromRussianToParam.convert(str)
    end
  end

  def kinds_links
    @kinds_links ||= [].tap do |kinds_links|
      self.class.suborganization_kinds.map(&:name).map(&:underscore).each do |suborganization_kind|
        kinds_links << {
          title: I18n.t("organization.kind.#{suborganization_kind}"),
          klass: suborganization_kind,
          url: "#{suborganization_kind.pluralize}_path",
          parameters: {},
          selected: selected_kind == suborganization_kind,
        }
      end
    end
  end

  def categories_links
    @categories_links ||= [].tap { |array|
      HasSearcher.searcher(pluralized_kind.to_sym).facet("#{kind}_category").rows.map do |row|
        array << {
          title: row.value.mb_chars.capitalize,
          klass: FromRussianToParam.convert(row.value),
          url: "#{kind.pluralize}_#{FromRussianToParam.convert(row.value).pluralize}_path",
          parameters: {},
          selected: categories_filter[:selected].include?(row.value.mb_chars.downcase),
          count: row.count
        }
      end
      add_advanced_categories_links(array)
      array.sort_by! {|c| c[:count]}.reverse!
      array.insert(0, {
        title: 'Все',
        klass: 'all',
        url: "#{pluralized_kind}_path",
        parameters: {},
        selected: array.select {|a| a[:selected]}.empty?,
        count: HasSearcher.searcher(pluralized_kind.to_sym).total
      })
    }
  end

  def sortings_links
    @sortings_links ||= [].tap { |array|
      self.class.available_sortings_without_nearness.each do |sorting_value|
        array << {
          title: I18n.t("organization.sort.#{sorting_value}"),
          url: pluralized_kind == selected_category.pluralize ? "#{pluralized_kind}_path" : "#{pluralized_kind}_#{selected_category.pluralize}_path",
          parameters: {
            :order_by => sorting_value
          },
          selected: order_by == sorting_value
        }
      end
    }
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

  def add_advanced_categories_links(links)
    links
  end
end

