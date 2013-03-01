class EntertainmentsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :features,
                :offers,
                :lat, :lon, :radius,
                :order_by,
                :page, :per_page

  def initialize(args)
    super(args)

    @page ||= 1
    @per_page = 12
    @order_by = %w[nearness popularity].include?(order_by) ? order_by : 'popularity'
  end

  def collection
    EntertainmentDecorator.decorate searcher.results
  end

  def paginated_collection
    searcher.results
  end

  [:categories, :features, :offers].each do |field|
    define_method "#{field}_filter" do
      Hashie::Mash.new.tap { |h|
        h[:selected] = send(field) || []
        h[:available] = HasSearcher.searcher(:entertainment).facet("entertainment_#{field.to_s.singularize}").rows.map(&:value)
        h['used?'] = send(field).present? && send(field).any?
      }
    end
  end

  def geo_filter
    Hashie::Mash.new.tap { |h|
      h[:lat] = lat
      h[:lon] = lon
      h[:radius] = radius
      h['used?'] = lat.present? && lon.present? && radius.present?
    }
  end


  def searcher_params
    @searcher_params ||= {}.tap do |params|
      [:category, :feature, :offer].map(&:to_s).each do |field|
        params["entertainment_#{field}".to_sym]  = send("#{field.pluralize}_filter").selected if send("#{field.pluralize}_filter").used?
      end

      params[:location] = { lat: geo_filter.lat, lon: geo_filter.lon, radius: geo_filter.radius } if geo_filter.used?
    end
  end

  private

  def searcher
    @searcher ||= HasSearcher.searcher(:entertainments, searcher_params).tap { |s|
      s.paginate(page: page, per_page: per_page)

      #order_by_popularity? ? s.order_by_popularity : s.order_by_nearness
    }
  end
end
