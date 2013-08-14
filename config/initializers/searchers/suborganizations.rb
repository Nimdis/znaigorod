Organization.basic_suborganization_kinds.each do |kind|
  klasses = case kind
            when 'entertainment'
              [Entertainment, Sauna]
            when 'car_sales_center'
              [CarSalesCenter, CarWash]
            else
              [kind.classify.constantize]
            end

  HasSearcher.create_searcher kind.pluralize.to_sym do
    case kind
    when 'entertainment'
      models :entertainment, :sauna
    when 'car_sales_center'
      models :car_sales_center, :car_wash
    else
      models kind.to_sym
    end

    klasses.each do |klass|
      klass.facets.map { |facet| "#{kind}_#{facet}" }.each do |field|
        property field do |search|
          search.with(field, search_object.send(field)) if search_object.send(field).try(:any?)
        end
      end
    end

    scope do
      klasses.each do |klass|
        klass.facets.map { |facet| "#{kind}_#{facet}" }.each do |field|
          facet field, sort: :index
        end
      end

    end

    # OPTIMIZE: special cases
    scope :remove_duplicated do
      with(:show_in_search_results, true) if klasses.include?(Entertainment) || klasses.include?(CarSalesCenter)
    end

    property :location do |search|
      search.with(:location).in_radius(search_object.location[:lat], search_object.location[:lon], search_object.location[:radius]) if search_object.location
    end

    scope(:order_by_rating) { order_by :organization_total_rating, :desc }

    scope :order_by_nearness do |search|
      search.order_by_geodist(:location, search_object.location.lat, search_object.location.lon) if search_object.location
    end

    scope(:order_by_title) { order_by :organization_title }
  end
end
