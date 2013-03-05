# encoding: utf-8

class AfficheCollection
  include Rails.application.routes.url_helpers
  include ActiveAttr::MassAssignment
  include ActionView::Helpers
  attr_accessor :kind, :period, :on, :tags, :page, :categories, :list_settings, :presentation_mode, :sort, :organization

  def initialize(options)
    super(options)
    begin
      self.on = Date.parse(self.on)
    rescue
      self.on = Date.today
    end if self.daily_period?
    self.categories ||= ""
    self.kind ||= 'affiches'
    self.period ||= 'all'
    query = "categories/#{self.categories}/tags/#{self.tags}"
    query = "categories/#{self.categories}" if self.categories.include?('tags')
    parameters = {}
    query.split(/(categories|tags)/).tap(&:shift).each_slice(2) do |key, values| parameters[key] = values.split('/').keep_if(&:present?) end
    self.tags = parameters['tags'] || []
    self.categories = parameters['categories'] || []

    self.list_settings = list_settings.present? ? JSON.parse(list_settings) : {}
    self.presentation_mode = list_settings['presentation'] || 'posters'
    self.sort = !!list_settings['sort'].try(:any?) ? list_settings['sort'] : ['popular']
  end

  def meta_keywords
    tag(:meta, name: 'keywords', content: AfficheCollectionKeywords.new(self).to_s)
  end

  def view_partial
    return 'affiches/affiches_list' if presentation_mode == 'list'
    return 'affiches/affiches_posters'
  end

  def per_page
    return 6 if presentation_mode == '3dtour'
    return 5 if presentation_mode == 'list'
    return 12
  end

  def kind_links
    links = []
    ([Affiche] + Affiche.ordered_descendants).each do |affiche_kind|
      kind = affiche_kind.model_name.downcase.pluralize
      links << Link.new(:title => affiche_kind.model_name.human, :current => kind  == self.kind, :kind => kind, :html_options => {}, :url => affiches_path(kind, period, on))
    end
    current_index = links.index { |link| link.current? }
    links[current_index - 1].html_options[:class] = :before_current if current_index > 0
    links[current_index + 1].html_options[:class] = :after_current if current_index < links.size - 1
    links[current_index].html_options[:class] = :current
    links
  end

  def period_links
    links = []
    %w(today weekly weekend daily all).each do |affiche_period|
      link_title = human_period(affiche_period)
      link_title += "&nbsp;(#{counter.send(affiche_period)})" unless affiche_period == 'daily'
      html_options = affiche_period == 'daily' ? { :class => 'daily ' } : { :class => '' }
      links << Link.new(:title => link_title.html_safe,
                        :current => affiche_period == period,
                        :html_options => html_options,
                        :url => organization ? affiche_organization_path(organization, period: affiche_period) : affiches_path(kind: kind, period: affiche_period))

    end
    current_index = links.index { |link| link.current? }
    links[current_index - 1].html_options[:class] += 'before_current' if current_index > 0
    links[current_index + 1].html_options[:class] += 'after_current' if current_index < links.size - 1
    links[current_index].html_options[:class] += 'current'
    links
  end

  def counter
    Counter.new(:kind => kind.singularize, :organization => organization)
  end

  def all_tags
    searcher_params = search_params
    searcher_params.delete(:tags)
    searcher_params.delete(:affiche_category) if categories.any?
    searcher(searcher_params).faceted.facet(:tags).rows.map(&:value)
  end

  def presented_tags
    searcher_params = search_params
    searcher(searcher_params).faceted.facet(:tags).rows.map(&:value)
  end

  def categories_links
    searcher_params = search_params
    searcher_params.delete(:affiche_category)
    existed_categories = searcher(searcher_params).categories.group(:affiche_category).groups.map(&:value)
    [].tap do |array|
      Affiche.ordered_descendants.each do |category|
        array << Link.new(title: category.model_name.human.mb_chars.downcase,
                          url: affiches_path(kind, period, on, categories: tag_params('categories', category.model_name.downcase.pluralize), tags: tags.any? ? tags : nil),
                          current: categories.include?(category.model_name.downcase.pluralize),
                          html_options: categories.include?(category.model_name.downcase.pluralize) ? { class: 'selected' } : {},
                          disabled: !existed_categories.include?(category.model_name.downcase)
                         )
      end
    end
  end

  def tag_links
    linked_tags = presented_tags
    [].tap do |array|
      all_tags.each do |tag|
        html_options = tags.include?(tag) ? { :class => 'selected' } : {}
        array << Link.new(:title => tag, :current => tags.include?(tag), :html_options => html_options, :url => url_for_tag(tag), :disabled => !linked_tags.include?(tag))
      end
    end
  end

  def url_for_tag(tag)
    organization ? affiche_organization_path(organization, period: period, on: on, tags: tag_params('tags', tag)) : affiches_path(kind, period, on, tags: tag_params('tags',tag), categories: categories.any? ? categories : nil)
  end

  def daily_period?
    period == 'daily'
  end

  def all_kinds?
    kind == 'affiches'
  end

  def human_period(affiche_period = nil)
    return "" if affiche_period.nil? && period == 'all'
    affiche_period ||= period
    return I18n.l(on, :format => '%e %B') if affiche_period == 'daily' && on && on.is_a?(Date)
    return I18n.t("affiche_periods.all.#{kind}") if affiche_period == 'all'
    I18n.t("affiche_periods.#{affiche_period}")
  end

  def human_kind
    return I18n.t("affiche_periods.all.#{kind}") if period == 'all'
    I18n.t("activerecord.models.#{kind.singularize}")
  end

  def meta_tags
    res = ''
    desc = I18n.t("meta_description.#{kind}.#{period}") unless daily_period?
    desc = I18n.t("meta_description.#{kind}.#{period}", date: I18n.l(on, format: '%e %B')).squish if daily_period?
    res << "<meta name='description' content='#{desc}' />\n"
    res.html_safe
  end

  def affiches
    searcher(search_params).paginate(:page => page, :per_page => per_page).affiches.group(:affiche_id_str).groups.map do |group|
      affiche = Affiche.find(group.value)
      showings = group.hits.map(&:result)

      AfficheDecorator.new(affiche, ShowingDecorator.decorate(showings))
    end
  end

  def paginated_affiches
    searcher(search_params).paginate(:page => page, :per_page => per_page).affiches.group(:affiche_id_str).groups
  end

  def searcher_scopes
    [].tap do |scopes|
      case period
      when 'today'
        scopes << 'today'
        scopes << 'actual'
      when 'daily'
        scopes << 'today' if  on == Date.today
      when 'weekend'
        scopes << 'weekend'
        scopes << 'actual'
      when 'weekly'
        scopes << 'weekly'
        scopes << 'actual'
      when 'all'
        scopes << 'actual'
      end

      (scopes << sort_scopes).flatten!
    end
  end

  def sort_scopes
    [].tap do |scopes|
      scopes << 'order_by_starts_at'          if sort.include?('closest')
      scopes << 'order_by_affiche_created_at' if sort.include?('newest')
      scopes << 'order_by_affiche_popularity' if sort.include?('popular')
    end
  end

  def sort_links
    links = []

    %w[popular newest closest].each do |order|
      links << content_tag(:li,
                           Link.new(
                                    :title => I18n.t("affiche.sort.#{order}"),
                                    :html_options => sort.include?(order) ? { class: "#{order} selected"} : { class: order },
                                    :url => (organization ? affiche_organization_path(organization, period: period) : affiches_path(kind: kind, period: period, on: on))
      ))
    end

    (links.join(content_tag(:li, content_tag(:span, '&nbsp;'.html_safe, class: 'separator')))).html_safe
  end

  private

  def searcher(searcher_params)
    HasSearcher.searcher(:affiche, searcher_params).tap do |searcher|
      searcher_scopes.each do |scope|
        searcher.send(scope)
      end
    end
  end

  def search_params(affiche_id = nil)
    search_params = {}
    search_params[:affiche_category] = (kind == 'affiches' ? categories.map(&:singularize) : kind.singularize)
    search_params[:starts_on] = on if period == 'daily'
    search_params[:tags] = tags if tags.any?
    search_params[:affiche_id] = affiche_id if affiche_id
    search_params[:organization_id] = organization.id if organization
    search_params
  end

  def tag_params(filter, tag)
    to_params_arr = self.send(filter).dup
    if to_params_arr.include?(tag)
      to_params_arr = to_params_arr - [tag]
    else
      to_params_arr << tag
    end
    to_params_arr.any? ? to_params_arr.join("/") : nil
  end
end
