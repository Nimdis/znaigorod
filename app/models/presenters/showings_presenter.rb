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
                :order_by,
                :page, :per_page

  def initialize(args)
    super(args)

    @page ||= 1
    @per_page = 10
    @order_by = %w[nearness popularity].include?(order_by) ? order_by : 'popularity'
  end

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

  def categories_filter
    @categories_filter ||= CategoriesFilter.new(categories)
  end

  def period_filter
    @period_filter ||= PeriodFilter.new(period)
  end

  def price_filter
    @price_filter ||= PriceFilter.new(price_min, price_max)
  end


  def age_filter
    @age_filter ||= AgeFilter.new(age_min, age_max)
  end

  def time_filter
    @time_filter ||= TimeFilter.new(time_from, time_to)
  end

  def organizations_filter
    @organizations_filter ||= OrganizationsFilter.new(organization_ids)
  end

  def tags_filter
    @tags_filter ||= TagsFilter.new(tags)
  end

  def partial
    #'affiches/affiches_posters'
    'affiches/affiches_list'
  end

  def query
    searcher_params
  end

  private

  def searcher_params
    {}.tap do |params|
      params[:categories]       = categories_filter.selected if categories_filter.selected.any?
      params[:organization_ids] = organizations_filter.ids   if organizations_filter.ids.any?
      params[:starts_on]        = period_filter.date         if period_filter.date?
      params[:tags]             = tags_filter.selected       if tags_filter.selected.any?
    end
  end

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
