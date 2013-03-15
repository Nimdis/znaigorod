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

HasSearcher.create_searcher :manage_organization do
  models :organization

  keywords :q

  property :status
  property :user_id
  property :suborganizations
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
