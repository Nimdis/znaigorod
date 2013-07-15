# OPTIMIZE: after changes needs reboot even in development

class CategoriesFilter
  attr_accessor :selected, :available, :human_names

  def initialize(categories, hidden = false)
    @selected    = (categories || []).delete_if(&:blank?)
    @available   = Affiche.kind.values
    @human_names = Affiche.kind.values.map(&:text)
    @hidden = !!hidden
  end

  def used?
    selected.any?
  end

  def hidden?
    @hidden
  end

  def only_category
    selected.first if hidden?
  end
end

class PeriodFilter
  def initialize(period)
    @date = period.to_date rescue nil
    @period = period
  end

  def date
    @date || (->{ Date.today }.call)
  end

  def period
    available_period_values.include?(@period) ? @period : available_period_values.last
  end

  def date?
    !!@date
  end

  def used?
    true
  end

  def self.available_period_values
    %w[today week weekend all]
  end

  def available_period_values
    self.class.available_period_values
  end

  available_period_values.each do |name|
    define_method "#{name}?" do
      name == @period
    end
  end

  def all?
    @period == 'all' || @period.nil?
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
    Hashie::Mash.new(
      #minimum: Affiche.with_showings.joins(:showings).minimum(:age_min),
      #maximum: Affiche.with_showings.joins(:showings).maximum(:age_max)
      minimum: 0, maximum: 99
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
  attr_accessor :selected

  def initialize(ids)
    @selected = (ids || []).map(&:to_i)
  end
  alias_method :ids, :selected

  def available
    @available ||= Organization.where(id: Showing.search { facet(:organization_ids, limit: 500) }.facet(:organization_ids).rows.map(&:value)).
      order(:title).
      map { |o| { name: o.title, id: o.id } }
  end

  def used?
    selected.any?
  end
end

class TagsFilter
  attr_accessor :selected

  def initialize(tags, category = nil)
    @selected = (tags || []).delete_if(&:blank?)
    @category = category
  end

  def available
    options = @category ? { categories: [@category] } : {}
    @available ||= HasSearcher.searcher(:showings, options).actual.facets.facet(:tags).rows.map(&:value)
  end

  def used?
    selected.any?
  end
end

class GeoFilter
  attr_accessor :lat, :lon, :radius

  def initialize(lat, lon, radius)
    @lat, @lon, @radius = lat, lon, radius
  end

  def used?
    lat.present? && lon.present? && radius.present?
  end
end
