# encoding: utf-8

require 'showings_presenter_filter'

class ShowingsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :price_min, :price_max,
                :age_min, :age_max,
                :time_from, :time_to,
                :organization_ids,
                :tags,
                :page, :per_page

  def initialize(args = {})
    super(args)

    self.organization_ids = (self.organization_ids || []).map(&:to_i)
  end

  def sort_links
    '=== SORT LINKS ==='
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

  def place_filter
    @place_filter ||= Hashie::Mash.new.tap { |h|
      h[:available] = Organization.where(:id => Organization.joins(:showings).pluck('DISTINCT organizations.id')).map { |o| { :label => o.title, :value => o.id } }
      h[:selected] = h.available.select { |e| organization_ids.include?(e) }
      h[:used?] = h.selected.any? ? true : false
    }
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
    @search ||= Showing.search {
      group(:affiche_id_str) { limit 1000 }
      paginate(:page => page, :per_page => 10)

      any_of do
        with(:starts_at).greater_than DateTime.now.beginning_of_day
        with(:ends_at).greater_than DateTime.now.beginning_of_day
      end

      with(:affiche_category, categories_filter.selected) if categories_filter.selected.any?

      without(:price_max).less_than(price_filter.selected.minimum) if price_filter.minimum.present?
      without(:price_min).greater_than(price_filter.selected.maximum) if price_filter.maximum.present?

      #age

      without(:ends_at_hour).less_than(time_filter.selected.from) if time_filter.from.present?
      without(:starts_at_hour).greater_than(time_filter.selected.to) if time_filter.to.present?

      #place

      with(:tags, tags_filter.selected) if tags_filter.selected.any?
    }
  end
end
