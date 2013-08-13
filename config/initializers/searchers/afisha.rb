HasSearcher.create_searcher :showings do
  models :showing

  # facets
  scope :facets do
    facet(:tags, limit: 500, sort: :index)
    facet(:organization_ids, limit: 500)
  end

  # groups
  scope :groups do
    group(:afisha_id_str) { limit 1000 }
  end

  # order
  scope(:order_by_rating)     { order_by(:afisha_rating, :desc) }
  scope(:order_by_creation)   { order_by(:afisha_created_at, :desc) }
  scope(:order_by_starts_at)  { order_by(:starts_at, :asc) }

  scope :order_by_nearness do |search|
    search.order_by_geodist(:location, search_object.location.lat, search_object.location.lon) if search_object.location
  end

  property :afisha_id
  property :afisha_state
  property :has_tickets

  # categories tags organizations
  [:categories, :tags, :organization_ids].each do |field|
    property field do |search|
      search.with(field, search_object.send(field)) if search_object.send(field).try(:any?)
    end
  end

  # price
  property :price_max do |search|
    search.any_of do
      with(:price_max).greater_than_or_equal_to(search_object.price_min)
      with(:price_max, nil)
    end if search_object.price_min.present?
  end

  property :price_min do |search|
    search.with(:price_min).less_than_or_equal_to(search_object.price_max) if search_object.price_max.present?
  end

  # age
  property :age_max do |search|
    search.any_of do
      with(:age_max).greater_than_or_equal_to(search_object.age_min)
      with(:age_max, nil)
    end if search_object.age_min.present?
  end

  property :age_min do |search|
    search.with(:age_min).less_than_or_equal_to(search_object.age_max) if search_object.age_max.present?
  end

  #time
  property :to do |search|
    search.with(:ends_at_hour).greater_than_or_equal_to(search_object.from) if search_object.from.present?
  end

  property :from do |search|
    search.with(:starts_at_hour).less_than_or_equal_to(search_object.to) if search_object.to.present?
  end

  # period
  scope :actual do |search|
    search.any_of do
      with(:starts_at).greater_than DateTime.now.beginning_of_day
      with(:ends_at).greater_than DateTime.now.beginning_of_day
    end
  end

  property :location do |search|
    search.with(:location).in_radius(search_object.location[:lat], search_object.location[:lon], search_object.location[:radius]) if search_object.location
  end

  scope :today do
    with(:starts_at).less_than DateTime.now.end_of_day
  end

  scope :week do |search|
    search.any_of do
      all_of do
        with(:starts_at).greater_than DateTime.now.beginning_of_week
        with(:starts_at).less_than DateTime.now.end_of_week
        with(:ends_at, nil)
      end

      all_of do
        with(:starts_at).less_than DateTime.now.end_of_week
        with(:ends_at).greater_than DateTime.now.beginning_of_week
      end
    end
  end

  scope :weekend do |search|
    search.any_of do
      all_of do
        with(:starts_at).greater_than DateTime.now.end_of_week - 2.days + 1.second
        with(:starts_at).less_than DateTime.now.end_of_week
        with(:ends_at, nil)
      end

      all_of do
        with(:starts_at).less_than DateTime.now.end_of_week
        with(:ends_at).greater_than DateTime.now.end_of_week - 2.days + 1.second
      end
    end
  end

  property :starts_on do |search|
    search.any_of do
      all_of do
        with(:starts_at).greater_than search_object.starts_on.beginning_of_day
        with(:starts_at).less_than search_object.starts_on.end_of_day
        with(:ends_at, nil)
      end

      all_of do
        with(:starts_at).less_than search_object.starts_on.end_of_day
        with(:ends_at).greater_than search_object.starts_on.beginning_of_day
      end
    end if search_object.starts_on
  end
end

HasSearcher.create_searcher :similar_afisha do
  models :afisha

  scope do
    with(:last_showing_time).greater_than HasSearcher.cacheable_now
  end

  scope :with_images do
    with(:has_images, true)
  end
end
