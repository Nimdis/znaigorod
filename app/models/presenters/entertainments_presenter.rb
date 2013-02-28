class EntertainmentsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :price_min, :price_max,
                :age_min, :age_max,
                :time_from, :time_to,
                :organization_ids,
                :tags,
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
    searcher.results
  end

  def searcher_params
    @searcher_params ||= {}.tap do |params|
      #params[:age_max]          = age_filter.maximum         if age_filter.maximum.present?
      #params[:age_min]          = age_filter.minimum         if age_filter.minimum.present?
      #params[:categories]       = categories_filter.selected if categories_filter.selected.any?
      #params[:organization_ids] = organizations_filter.ids   if organizations_filter.ids.any?
      #params[:price_max]        = price_filter.maximum       if price_filter.maximum.present?
      #params[:price_min]        = price_filter.minimum       if price_filter.minimum.present?
      #params[:tags]             = tags_filter.selected       if tags_filter.selected.any?
      #params[:from]             = time_filter.from           if time_filter.from.present?
      #params[:to]               = time_filter.to             if time_filter.to.present?

      #params[:location]         = { lat: geo_filter.lat, lon: geo_filter.lon, radius: geo_filter.radius } if geo_filter.used?
    end
  end

  private

  def searcher
    @searcher ||= HasSearcher.searcher(:entertainments).tap { |s|
      #s.paginate(page: page, per_page: per_page).groups

      #order_by_popularity? ? s.order_by_popularity : s.order_by_nearness
    }
  end
end
