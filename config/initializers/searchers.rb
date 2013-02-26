HasSearcher.create_searcher :showings do
  models :showing

  # facets
  scope :facets do
    facet(:tags, limit: 500, sort: :index)
    facet(:organization_ids, limit: 500)
  end

  # groups
  scope :groups do
    group(:affiche_id_str) { limit 1000 }
  end

  # order
  scope(:order_by_nearness)   { order_by(:starts_at, :asc) }
  scope(:order_by_popularity) { order_by(:affiche_popularity, :desc) }

  # categories tags organizations
  [:categories, :tags, :organization_ids].each do |field|
    property field do |search|
      search.with(field, search_object.send(field)) if search_object.send(field).try(:any?)
    end
  end

  # price
  property :price_max do |search|
    without(:price_max).less_than(search_object.price_min) if search_object.price_min.present?
  end

  property :price_min do |search|
    without(:price_min).greater_than(search_object.price_max) if search_object.price_max.present?
  end

  # age
  property :age_max do |search|
    without(:age_max).less_than(search_object.age_min) if search_object.age_min.present?
  end

  property :age_min do |search|
    without(:age_min).greater_than(search_object.age_max) if search_object.age_max.present?
  end

  #time

  # period
  scope :actual do |search|
    search.any_of do
      with(:starts_at).greater_than DateTime.now.beginning_of_day
      with(:ends_at).greater_than DateTime.now.beginning_of_day
    end
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

HasSearcher.create_searcher :affiche do
  models :showing

  property :affiche_category do |search|
    search.with(:affiche_category, search_object.affiche_category) if search_object.affiche_category.present?
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

  property :tags do |search|
    search.with(:tags, search_object.tags) if search_object.tags.present?
  end

  property :affiche_id
  property :organization_id

  scope :today do
    with(:starts_at).less_than DateTime.now.end_of_day
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

  scope :weekly do |search|
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

  scope :actual do |search|
    search.any_of do
      with(:starts_at).greater_than DateTime.now.beginning_of_day
      with(:ends_at).greater_than DateTime.now.beginning_of_day
    end
  end

  scope :affiches do
    group :affiche_id_str do
      limit 1000
    end
  end

  scope :categories do
    group :affiche_category
  end

  scope :order_by_starts_at do
    order_by(:starts_at, :asc)
  end

  scope :order_by_affiche_created_at do
    order_by(:affiche_created_at, :desc)
  end

  scope :order_by_affiche_popularity do
    order_by(:affiche_popularity, :desc)
  end

  scope :faceted do
    facet(:tags)
  end
end

HasSearcher.create_searcher :similar_affiches do
  models :affiche

  scope do
    with(:last_showing_time).greater_than HasSearcher.cacheable_now
  end

  scope :with_images do
    with(:has_images, true)
  end
end

HasSearcher.create_searcher :similar_posts do
  models :post
end

HasSearcher.create_searcher :photoreport do
  models :image

  property :category
  property :tags

  scope :weekly do
    with(:created_at).greater_than 1.week.ago.beginning_of_day
  end

  scope :monthly do
    with(:created_at).greater_than 1.month.ago.beginning_of_day
  end

  scope do
    facet(:category)
    facet(:tags)

    order_by :id, :desc

    with(:imageable_type, 'Affiche')
  end

  scope :grouped do
    group :imageable_id_str
  end
end

HasSearcher.create_searcher :actual_organization do
  models :meal, :entertainment, :culture

  property :meal_offer
  property :meal_category

  property :entertainment_category
  property :entertainment_offer

  property :culture_category
  property :culture_offer

  scope do
    #adjust_solr_params { |params| params[:q] = "{!boost b=organization_rating_f}*:*" }
    order_by(:organization_rating, :desc)
  end
end

HasSearcher.create_searcher :meal do
  models :meal

  property :meal_category
  property :meal_feature
  property :meal_offer
  property :meal_cuisine
  property :meal_stuff

  scope do
    #adjust_solr_params { |params| params[:q] = "{!boost b=organization_rating_f}*:*" }
    order_by(:organization_rating, :desc)

    facet(:meal_category)
    facet(:meal_feature)
    facet(:meal_offer)
    facet(:meal_cuisine)
    facet(:meal_stuff)
  end
end

HasSearcher.create_searcher :entertainment do
  models :entertainment

  property :entertainment_category
  property :entertainment_feature
  property :entertainment_offer
  property :entertainment_type
  property :entertainment_stuff

  scope do
    #adjust_solr_params { |params| params[:q] = "{!boost b=organization_rating_f}*:*" }
    order_by(:organization_rating, :desc)

    facet(:entertainment_category)
    facet(:entertainment_feature)
    facet(:entertainment_offer)
    facet(:entertainment_stuff)
  end
end

HasSearcher.create_searcher :culture do
  models :culture

  property :culture_category
  property :culture_feature
  property :culture_offer
  property :culture_stuff

  scope do
    #adjust_solr_params { |params| params[:q] = "{!boost b=organization_rating_fs}*:*" }
    order_by(:organization_rating, :desc)

    facet(:culture_category)
    facet(:culture_feature)
    facet(:culture_offer)
    facet(:culture_stuff)
  end
end

HasSearcher.create_searcher :sport do
  models :sport

  property :sport_category
  property :sport_feature
  property :sport_stuff

  scope do
    #adjust_solr_params { |params| params[:q] = "{!boost b=organization_rating_f}*:*" }
    order_by(:organization_rating, :desc)

    facet(:sport_category)
    facet(:sport_feature)
    facet(:sport_stuff)
  end
end

HasSearcher.create_searcher :creation do
  models :creation

  property :creation_category
  property :creation_feature
  property :creation_stuff

  scope do
    #adjust_solr_params { |params| params[:q] = "{!boost b=organization_rating_f}*:*" }
    order_by(:organization_rating, :desc)

    facet(:creation_category)
    facet(:creation_feature)
    facet(:creation_stuff)
  end
end

HasSearcher.create_searcher :organizations do
  models :organization
  keywords :q

  scope :order_by_rating do
    order_by(:rating, :desc)
  end

  # NOTE: как передать значения в scope? o_O
  scope :nearest do |search|
    search.with(:location).in_radius(search_object.latitude, search_object.longitude, 0.5, bbox: true)
    search.order_by_geodist(:location, search_object.latitude, search_object.longitude)
  end
end

#HasSearcher.create_searcher :showings do
  #models :showing
  #keywords :q

  #scope :affiche_groups do
    #group(:affiche_id_str)
  #end
#end

HasSearcher.create_searcher :showing do
  models :showing

  property :affiche_id
  property :affiche_category
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
  property :affiche_category

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

HasSearcher.create_searcher :manage_organization do
  models :organization
  keywords :q
end

HasSearcher.create_searcher :global do
  models :organization, :affiche
  keywords :q do
    highlight :title_translit
    highlight :description_ru
    highlight :address_ru
    HitDecorator::ADDITIONAL_FIELDS.each do |field|
      if (Organization.instance_methods + Affiche.instance_methods).include? :"#{field}_ru"
        highlight "#{field}_ru"
      else
        highlight field
      end
    end
    boost 1 do
      any_of do
        with(:last_showing_time).greater_than(HasSearcher.cacheable_now)
        with(:kind, 'organization')
      end
    end
    boost(
      function {
        sum(
          div(:popularity, Affiche.maximum(:popularity)),
          div(:rating, Organization.maximum(:rating))
        )
      }
    )
  end
  scope do
    adjust_solr_params do |params|
      (params[:qf] || '').gsub! /\bterm_text\b/, ''
      params[:fl] = 'id score'
    end
  end
end
