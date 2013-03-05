class AfficheToday
  include Rails.application.routes.url_helpers
  attr_accessor :kind

  def initialize(kind = nil)
    self.kind = kind || default_kind
  end

  def default_kind
    settings_kinds = []
    today = Time.now.strftime('%A').downcase
    times = Settings["app.affiche_today.#{today}"]
    times.each do |interval, kinds|
      interval = interval.to_s.split("-").map(&:to_i)
      from, to = interval.first, interval.second
      time_now = Time.now.strftime('%H').to_i
      if time_now >= from && time_now < to
        settings_kinds = kinds
        break
      end
    end
    settings_kinds[Random.rand(0..settings_kinds.size - 1)].downcase
  end

  def affiche_descendants_for_main_page
    Affiche.ordered_descendants
  end

  def affiches_path_with_params(kind, period)
    categories = [kind.to_s.singularize]

    query = {}.tap do |hash|
      hash[:categories] = categories
      hash[:period] = period if period.present?
    end

    affiches_path(query)
  end

  def links
    links = []
    affiche_descendants_for_main_page.each do |affiche_kind|
      kind = affiche_kind.model_name.downcase.pluralize
      links << Link.new(:title => affiche_kind.model_name.human, :current => kind == self.kind, :kind => kind, :html_options => {}, :url => affiches_path_with_params(kind, :today))
    end
    current_index = links.index { |link| link.current? }
    links[current_index - 1].html_options[:class] = :before_current if current_index > 0
    links[current_index + 1].html_options[:class] = :after_current if current_index < links.size - 1
    links[current_index].html_options[:class] = :current
    links
  end

  def current_link
    links.select{ |link| link.current? }.first
  end

  def counters
    counters = {}

    Affiche.ordered_descendants.each do |affiche_kind|
      counters[affiche_kind.model_name.downcase.pluralize] = Counter.new(:kind => affiche_kind.model_name.downcase)
    end

    counters
  end

  def affiches
    [].tap do |array|
      searcher(search_params).affiches.group(:affiche_id_str).groups.map(&:value).map { |id| Affiche.find(id) }.each do |affiche|
        array << AfficheDecorator.new(affiche, ShowingDecorator.decorate(searcher(search_params(affiche.id)).results))
      end
    end
  end

  private

  def searcher(searcher_params)
    HasSearcher.searcher(:affiche, searcher_params).today.actual
  end

  def search_params(affiche_id = nil)
    search_params = {}
    search_params[:affiche_category] = kind.singularize
    search_params[:affiche_id] = affiche_id if affiche_id
    search_params
  end
end
