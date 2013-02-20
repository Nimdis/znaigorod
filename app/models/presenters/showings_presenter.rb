# encoding: utf-8

require 'showings_presenter_filter'

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
    search.group(:affiche_id_str).groups.map do |group|
      affiche = Affiche.find(group.value)
      showings = group.hits.map(&:result)

      AfficheDecorator.new(affiche, ShowingDecorator.decorate(showings))
    end
  end

  def paginated_collection
    search.group(:affiche_id_str).groups
  end

  def total_count
    search.group(:affiche_id_str).total
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

  def search
    @search ||= Showing.search(:include => :affiche) {
      group(:affiche_id_str) { limit 1000 }
      paginate(:page => page, :per_page => 10)

      any_of do
        with(:starts_at).greater_than DateTime.now.beginning_of_day
        with(:ends_at).greater_than DateTime.now.beginning_of_day
      end

      with(:affiche_category, categories_filter.selected) if categories_filter.used?

      without(:price_max).less_than(price_filter.selected.minimum) if price_filter.minimum.present?
      without(:price_min).greater_than(price_filter.selected.maximum) if price_filter.maximum.present?

      #age

      without(:ends_at_hour).less_than(time_filter.selected.from) if time_filter.from.present?
      without(:starts_at_hour).greater_than(time_filter.selected.to) if time_filter.to.present?

      with(:organization_ids, organizations_filter.selected) if organizations_filter.used?

      with(:tags, tags_filter.selected) if tags_filter.selected.any?
    }
  end
end
