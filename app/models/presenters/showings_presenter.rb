# encoding: utf-8

class ShowingsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :categories,
                :price_min, :price_max,
                :time_from, :time_to,
                :tags

  def initialize(args = {})
    super(args)

    self.categories ||= []
    self.tags       ||= []

    self.price_min = self.price_min.blank? ? available_price_min : self.price_min
    self.price_max = self.price_max.blank? ? available_price_max : self.price_max

    self.time_from = self.time_from.blank? ? 0  : self.time_from
    self.time_to   = self.time_to.blank?   ? 23 : self.time_to
  end

  def sort_links
    '=== SORT LINKS ==='
  end

  def collection
    searcher.results
  end

  def total_count
    searcher.total
  end

  def categories_filter
    Hashie::Mash.new(
      available: Affiche.ordered_descendants.map(&:name).map(&:downcase),
      selected: categories,
      human_names: Affiche.ordered_descendants.map(&:model_name).map(&:human)
    )
  end

  def price_filter
    Hashie::Mash.new(
      available: {
        minimum: Affiche.with_showings.joins(:showings).minimum(:price_min),
        maximum: Affiche.with_showings.joins(:showings).maximum(:price_max)
      },
      selected: { minimum: price_min, maximum: price_max },
      used?: true
    )
  end

  def time_filter
    Hashie::Mash.new(
      available: { from: 0, to: 23 },
      selected: { from: time_from, to: time_to },
      used?: true
    )
  end

  def tags_filter
    Hashie::Mash.new(
      available: searcher.faceted.facet(:tags).rows.map(&:value),
      selected: tags,
      used?: tags.any? ? true : false
    )
  end

  def available_categories
    ['кино', 'концерты']
  end

  def selected_categories
    []
  end

  private

  def search_params
    #{}.tap do |params|
      #params[:tags] = tags_filter.selected if tags_filter.used?
    #end
    {}
  end

  def searcher(params = {})
    HasSearcher.searcher(:affiche, params)
  end
end
