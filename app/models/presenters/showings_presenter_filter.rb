# OPTIMIZE: after changes needs reboot even in development

class CategoriesFilter
  attr_accessor :selected, :available, :human_names

  def initialize(categories)
    @selected    = categories || []
    @available   = Affiche.ordered_descendants.map(&:name).map(&:downcase)
    @human_names = Affiche.ordered_descendants.map(&:model_name).map(&:human)
  end

  def used?
    selected.any?
  end
end

class PriceFilter
  attr_accessor :minimum, :maximum

  def initialize(minimum, maximum)
    @minimum, @maximum = minimum, maximum
  end

  def available
    Hashie::Mash.new(
      minimum: Affiche.with_showings.joins(:showings).minimum(:price_min),
      maximum: Affiche.with_showings.joins(:showings).maximum(:price_max)
    )
  end

  def selected
    Hashie::Mash.new(
      minimum: minimum.present? ? minimum : available.minimum,
      maximum: maximum.present? ? maximum : available.maximum
    )
  end

  def used?
    minimum.present? || maximum.present?
  end
end

class AgeFilter
  attr_accessor :minimum, :maximum

  def initialize(minimum, maximum)
    @minimum, @maximum = minimum, maximum
  end

  def available
    Hashie::Mash.new(minimum: 0, maximum: 100)
  end

  def selected
    Hashie::Mash.new(
      minimum: minimum.present? ? minimum : available.minimum,
      maximum: maximum.present? ? maximum : available.maximum
    )
  end

  def used?
    minimum.present? || maximum.present?
  end
end

class TimeFilter
  attr_accessor :from, :to

  def initialize(from, to)
    @from, @to = from, to
  end

  def available
    Hashie::Mash.new(from: 0, to: 23)
  end

  def selected
    Hashie::Mash.new(
      from: from.present? ? from : available.from,
      to:   to.present?   ? to   : available.to
    )
  end

  def used?
    from.present? || to.present?
  end
end

class OrganizationsFilter
  attr_accessor :selected, :available

  def initialize(ids=nil)
    @selected = Organization.where(id: ids).map(&:id)
  end

  def available
    Organization.where(id: Organization.joins(:showings).pluck('DISTINCT organizations.id')).
      map { |o| { name: o.title, id: o.id } }
  end

  def ids
    selected
  end

  def used?
    selected.any?
  end
end

class TagsFilter
  attr_accessor :selected, :available

  def initialize(tags)
    @selected = tags || []
    @available = Showing.search { facet(:tags) }.facet(:tags).rows.map(&:value)
  end

  def used?
    selected.any?
  end
end

