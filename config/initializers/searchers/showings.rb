HasSearcher.create_searcher :showing do
  models :showing

  property :afisha_category
  property :starts_on, :modificator => :less_than
  property :starts_at, :modificator => :greater_than
  property :starts_at_hour, :modificators => [:greater_than, :less_than]

  property :price, :modificators => [:greater_than, :less_than] do |search|
    if search_object.price_greater_than || search_object.price_less_than
      price_gt = [0, search_object.price_greater_than.to_i].max
      price_lt = search_object.price_less_than.to_i.zero? ? 10_000_000 : search_object.price_less_than.to_i

      search.with(:price_min).greater_than(price_gt)
      search.with(:price_min).less_than(price_lt)

      search.any_of do
        all_of do
          with(:price_min).greater_than(price_gt)
          with(:price_max).less_than(price_lt)
        end

        all_of do
          with(:price_min).less_than(price_gt)
          with(:price_max).greater_than(price_gt)
        end

        all_of do
          with(:price_min).less_than(price_lt)
          with(:price_max).greater_than(price_lt)
        end
      end
    end
  end

  property :tags
  property :afisha_category

  property :starts_on, :modificator => :greater_than do |search|
    starts_on_gt = search_object.starts_on_greater_than || Date.today
    ends_at_gt = search_object.starts_on_less_than || 1.week.since.to_date

    search.any_of do
      with(:starts_on).greater_than(starts_on_gt)
      with(:ends_at).greater_than(ends_at_gt)
    end
  end

  scope :actual do
    with(:starts_at).greater_than HasSearcher.cacheable_now
  end

  scope :today do
    with(:starts_at).less_than DateTime.now.end_of_day
  end

  scope :faceted do
    facet(:tags)
  end
end

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
  scope(:order_by_rating) { order_by(:afisha_rating, :desc) }
  scope(:order_by_creation)   { order_by(:afisha_created_at, :desc) }
  scope(:order_by_starts_at)  { order_by(:starts_at, :asc) }

  scope :order_by_nearness do |search|
    search.order_by_geodist(:location, search_object.location.lat, search_object.location.lon) if search_object.location
  end

  property :afisha_id
  property :afisha_state

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
