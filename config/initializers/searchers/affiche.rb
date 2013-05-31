# TODO: нужно использовать searcher :showings, а этот выпилить

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

  property :tags
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

  scope :order_by_affiche_rating do
    order_by(:affiche_rating, :desc)
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
  models :attachment

  property :category
  property :tags

  scope :weekly do
    with(:created_at).greater_than 1.week.ago.beginning_of_day
  end

  scope :monthly do
    with(:created_at).greater_than 1.month.ago.beginning_of_day
  end

  scope do
    any_of do
      with(:type, 'GalleryImage')
      with(:type, 'GallerySocialImage')
    end
    facet(:category)
    facet(:tags)

    order_by :id, :desc

    with(:attachable_type, 'Affiche')
  end

  scope :grouped do
    group :attachable_id_str
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
          div(:rating, Affiche.maximum(:total_rating)),
          div(:rating, Organization.maximum(:total_rating))
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
