# encoding: utf-8

require 'showings_presenter_filter'

class ShowingsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :period,
                :price_min, :price_max,
                :age_min, :age_max,
                :time_from, :time_to,
                :organization_ids,
                :tags,
                :lat, :lon, :radius,
                :order_by,
                :page, :per_page,
                :view

  def initialize(args)
    super(args)

    @page ||= 1
    @per_page = 12
    @order_by = %w[nearness popularity].include?(order_by) ? order_by : 'popularity'
    @view     = %w[list posters].include?(view) ? view : 'posters'

    initialize_filters
  end

  def initialize_filters
    @categories_filter    ||= CategoriesFilter.new(categories)
    @period_filter        ||= PeriodFilter.new(period)
    @price_filter         ||= PriceFilter.new(price_min, price_max)
    @age_filter           ||= AgeFilter.new(age_min, age_max)
    @time_filter          ||= TimeFilter.new(time_from, time_to)
    @organizations_filter ||= OrganizationsFilter.new(organization_ids)
    @tags_filter          ||= TagsFilter.new(tags)
    @geo_filter           ||= GeoFilter.new(lat, lon, radius)
  end
  attr_reader :age_filter, :categories_filter, :organizations_filter, :period_filter,
    :price_filter, :tags_filter, :time_filter, :geo_filter

  def order_by_popularity?
    order_by == 'popularity'
  end

  def collection
    searcher.group(:affiche_id_str).groups.map do |group|
      affiche = Affiche.find(group.value)
      showings = group.hits.map(&:result)

      AfficheDecorator.new(affiche, ShowingDecorator.decorate(showings))
    end
  end

  def paginated_collection
    searcher.group(:affiche_id_str).groups
  end

  def total_count
    searcher.group(:affiche_id_str).total
  end

  def view_list?
    view == 'list'
  end

  def partial
    "affiches/affiches_#{view}"
  end

  def today_affiche_links
    @today_affiche_links ||= Affiche.ordered_descendants.map { |descendant|
      {
        title: "#{descendant.model_name.human}",
        query: { categories: [descendant.name.downcase], period: 'today' },
        current: categories.include?(descendant.name.downcase),
        count: Counter.new(kind: descendant.name.downcase).today
      }
    }
  end

  def kind
    'movie'
  end

  def category_affiche_links
    @category_affiche_links ||= [].tap { |array|
      (period_filter.available_period_values - ['all']).each { |period|
        array << {
          title: "#{I18n.t("affiche_periods.#{period}")} (#{Counter.new(kind: kind).today})",
          query: { categories: [kind], period: period }
        }
      }

      array << {
        title: "#{I18n.t("affiche_periods.all.#{kind.pluralize}")} (#{Counter.new(kind: kind).all})",
        query: { categories: [kind] }
      }
    }
  end

  def searcher_params
    @searcher_params ||= {}.tap do |params|
      params[:age_max]          = age_filter.maximum         if age_filter.maximum.present?
      params[:age_min]          = age_filter.minimum         if age_filter.minimum.present?
      params[:categories]       = categories_filter.selected if categories_filter.selected.any?
      params[:organization_ids] = organizations_filter.ids   if organizations_filter.ids.any?
      params[:price_max]        = price_filter.maximum       if price_filter.maximum.present?
      params[:price_min]        = price_filter.minimum       if price_filter.minimum.present?
      params[:starts_on]        = period_filter.date         if period_filter.date?
      params[:tags]             = tags_filter.selected       if tags_filter.selected.any?

      params[:location]         = { lat: geo_filter.lat, lon: geo_filter.lon, radius: geo_filter.radius } if geo_filter.used?
    end
  end

  private

  def searcher
    @searcher ||= HasSearcher.searcher(:showings, searcher_params).tap { |s|
      s.paginate(page: page, per_page: per_page).groups

      order_by_popularity? ? s.order_by_popularity : s.order_by_nearness

      if period_filter.used? && !period_filter.date?
        case period_filter.period
        when 'today'
          s.today.actual
        when 'week'
          s.week.actual
        when 'weekend'
          s.weekend.actual
        end
      else
        s.actual
      end
    }
  end
end
