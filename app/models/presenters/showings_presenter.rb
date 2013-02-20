# encoding: utf-8

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

    self.categories ||= []
    self.tags       ||= []

    self.organization_ids = (self.organization_ids || []).map(&:to_i)

    self.price_min = self.price_min.blank? ? price_filter.available.minimum : self.price_min
    self.price_max = self.price_max.blank? ? price_filter.available.maximum : self.price_max

    self.age_min = self.age_min.blank? ? age_filter.available.minimum : self.age_min
    self.age_max = self.age_max.blank? ? age_filter.available.maximum : self.age_max

    self.time_from = self.time_from.blank? ? time_filter.available.from : self.time_from
    self.time_to   = self.time_to.blank?   ? time_filter.available.to   : self.time_to
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
    #search.total
    '+100500'
  end

  def categories_filter
    @categories_filter ||= Hashie::Mash.new.tap { |h|
      h[:available]   = Affiche.ordered_descendants.map(&:name).map(&:downcase)
      h[:selected]    = categories
      h[:human_names] = Affiche.ordered_descendants.map(&:model_name).map(&:human)
    }
  end

  def price_filter
    @price_filter ||= Hashie::Mash.new.tap { |h|
      h[:available] = {
        minimum: Affiche.with_showings.joins(:showings).minimum(:price_min),
        maximum: Affiche.with_showings.joins(:showings).maximum(:price_max)
      }

      h[:selected] = { minimum: price_min, maximum: price_max }
      h[:used?]    = true
    }
  end

  def age_filter
    @age_filter ||= Hashie::Mash.new.tap { |h|
      h[:available] = { minimum: 0, maximum: 100 }
      h[:selected] = { minimum: price_min, maximum: price_max }
      h[:used?]    = true
    }
  end

  def time_filter
    @time_filter ||= Hashie::Mash.new(
      available: { from: 0, to: 23 },
      selected: { from: time_from, to: time_to },
      used?: true
    )
  end

  def tags_filter
    @tags_filter ||= Hashie::Mash.new(
      available: search.facet(:tags).rows.map(&:value),
      selected: tags,
      used?: tags.any? ? true : false
    )
  end

  def place_filter
    @place_filter ||= Hashie::Mash.new.tap { |h|
      h[:available] = Organization.where(:id => Organization.joins(:showings).pluck('DISTINCT organizations.id')).map { |o| { :label => o.title, :value => o.id } }
      h[:selected] = h.available.select { |e| organization_ids.include?(e) }
      h[:used?] = h.selected.any? ? true : false
    }
  end

  private

  def search
    Showing.search {
      any_of do
        with(:starts_at).greater_than DateTime.now.beginning_of_day
        with(:ends_at).greater_than DateTime.now.beginning_of_day
      end

      with(:affiche_category, categories) if categories.any?
      with(:tags, tags) if tags.any?

      without(:price_max).less_than(price_min)    if price_min
      without(:price_min).greater_than(price_max) if price_max

      without(:ends_at_hour).less_than(time_from) if time_from
      without(:starts_at_hour).greater_than(time_to) if time_to

      facet(:tags)

      group :affiche_id_str do
        limit 1000
      end

      paginate(:page => page, :per_page => 30)
    }
  end
end
