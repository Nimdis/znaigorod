# encoding: utf-8

require 'showings_presenter_filter'

class PeriodFilter
  attr_accessor :period

  def initialize(period)
    @period = begin
                period.to_date
              rescue
                available_period_values.include?(period) ? period : available_period_values.first
              end
  end

  private

  def available_period_values
    %w[today week weekend all]
  end
end

class ShowingsPresenter
  include ActionView::Helpers
  include ActiveAttr::MassAssignment
  #include Rails.application.routes.url_helpers

  attr_accessor :categories,
                :price_min, :price_max,
                :age_min, :age_max,
                :time_from, :time_to,
                :organization_ids,
                :tags,
                :page, :per_page

  def initialize(args)
    super(args)

    @page ||= 1
    @per_page = 10
  end

  def sort_links
    links = []

    %w[popular newest closest].each do |order|
      links << content_tag(:li,
                           Link.new(
                                    :title => I18n.t("affiche.sort.#{order}"),
                                    :html_options => { class: order },
                                    :url => '#')
      )
    end

    (links.join(content_tag(:li, content_tag(:span, '&nbsp;'.html_safe, class: 'separator')))).html_safe
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

  private

  def searcher_params
    {
      categories: categories_filter.selected,
      organization_ids: organizations_filter.ids,
      tags: tags_filter.selected
    }
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:showings, searcher_params).
      paginate(page: page, per_page: per_page).actual.groups
  end
end
