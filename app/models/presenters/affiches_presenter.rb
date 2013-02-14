# encoding: utf-8

class AffichesPresenter
  include ActiveAttr::MassAssignment

  def initialize(args = {})
    super(args)
  end

  def sort_links
    '=== SORT LINKS ==='
  end

  def collection
    Affiche.search {}.results
  end

  def total_count
    collection.size
  end

  def price
    Hashie::Mash.new(
      available: { minimum: 0, maximum: 2500 },
      selected: { minimum: 200, maximum: 500 }
    )
  end

  def price_filter_used?
    true
  end

  def time
    Hashie::Mash.new(
      available: { minimum: 0, maximum: 23 },
      selected: { minimum: 10, maximum: 20 }
    )
  end

  def time_filter_used?
    true
  end

  def available_tags
    ['тег1', 'тег2']
  end

  def selected_tags
    []
  end

  def tags_filter_used?
    true
  end
end
