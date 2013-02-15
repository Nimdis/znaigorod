# encoding: utf-8

class AffichesPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :price_min, :price_max,
                :time_from, :time_to

  def initialize(args = {})
    super(args)

    self.price_min = self.price_min.blank? ? available_price_min : self.price_min
    self.price_max = self.price_max.blank? ? available_price_max : self.price_max

    self.time_from = self.time_from.blank? ? 0  : self.time_from
    self.time_to   = self.time_to.blank?   ? 23 : self.time_to
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

  def available_price_min
    Affiche.with_showings.joins(:showings).minimum(:price_min)
  end

  def available_price_max
    Affiche.with_showings.joins(:showings).maximum(:price_max)
  end

  def price
    Hashie::Mash.new(
      available: { minimum: available_price_min, maximum: available_price_max },
      selected: { minimum: price_min, maximum: price_max }
    )
  end

  def price_filter_used?
    true
  end

  def time
    Hashie::Mash.new(
      available: { from: 0, to: 23 },
      selected: { from: 10, to: 20 }
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
