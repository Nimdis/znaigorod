Organization.basic_suborganization_kinds.each do |kind|
  klass = kind.classify.constantize

  HasSearcher.create_searcher kind.pluralize.to_sym do
    models kind.to_sym

    klass.facets.map { |facet| "#{kind}_#{facet}" }.each do |field|
      property field do |search|
        search.with(field, search_object.send(field)) if search_object.send(field).try(:any?)
      end
    end

    scope do
      klass.facets.map { |facet| "#{kind}_#{facet}" }.each do |field|
        facet field, sort: :index
      end

    end

    # OPTIMIZE: special cases
    scope :remove_duplicated do
      with(:show_in_search_results, true) if klass == Entertainment
    end

    property :location do |search|
      search.with(:location).in_radius(search_object.location[:lat], search_object.location[:lon], search_object.location[:radius]) if search_object.location
    end

    scope(:order_by_popularity) { order_by :organization_rating, :desc }

    scope :order_by_nearness do |search|
      search.order_by_geodist(:location, search_object.location.lat, search_object.location.lon) if search_object.location
    end

    scope(:order_by_title) { order_by :organization_title }
  end
end
