#encoding: utf-8

class OrganizationDecorator < ApplicationDecorator
  decorates :organization

  def image_for_main_page
    unless organization.logotype_url.blank?
      h.link_to image_tag(organization.logotype_url, 100, 100, organization.title), organization_url
    else
      h.link_to h.image_tag("public/stub.jpg", :size => "100x100", :alt => organization.title, :title => organization.title), organization_url
    end
  end

  def logo_link(width = 80, height = 80)
    if organization.logotype_url?
      h.link_to image_tag(organization.logotype_url, width, height, organization.title.text_gilensize), organization_url
    end
  end

  def title_link
    h.link_to organization.title.text_gilensize.hyphenate, organization_url
  end

  def address_link(address = organization.address)
    return "" if organization.address.to_s.blank?
    h.link_to address.to_s,
      organization_url,
      :'data-latitude' => organization.address.latitude,
      :'data-longitude' => organization.address.longitude,
      :'data-hint' => organization.title.text_gilensize,
      :'data-id' => organization.id,
      :class => 'show_map_link'
  end

  def office
    return ", #{organization.address.office.squish}" unless organization.address.office.blank?
  end

  def show_url
    organization_url
  end

  def organization_url
    organization.subdomain? ? h.root_url(subdomain: organization.subdomain) : h.organization_url(organization)
  end

  def email_link
    h.mail_to email.squish unless email.blank?
  end

  def site_link
    h.link_to site.squish, site.squish, rel: "nofollow", target: "_blank" unless site.blank?
  end

  def contact_links
    content = ''
    content << site_link.to_s
    content << ', ' if content.present? && email_link.present?
    content << email_link.to_s

    content.html_safe
  end

  # FIXME: грязный хак ;(
  def fake_kind
    %w[billiard].include?(priority_suborganization_kind) ? 'entertainment' : priority_suborganization_kind
  end

  # FIXME: грязный хак ;(
  def fake_class(suborganization)
    [Billiard].include?(suborganization.class) ? Entertainment : suborganization.class
  end

  def breadcrumbs
    links = []
    links << h.content_tag(:li, h.link_to("Знай\u00ADГород", h.root_path), :class => "crumb")
    links << h.content_tag(:li, h.content_tag(:span, "&nbsp;".html_safe), :class => "separator")

    links << h.content_tag(:li, h.link_to(I18n.t("organization.list_title.#{fake_kind}") + " Томска ", h.send("#{fake_kind.pluralize}_path"), :class => "crumb"))
    links << h.content_tag(:li, h.content_tag(:span, "&nbsp;".html_safe), :class => "separator")

    if priority_category != I18n.t("organization.list_title.#{fake_kind}") && !%w(car_sales_center).include?(fake_kind)
      links << h.content_tag(:li, link_to_priority_category, :class => "crumb")
      links << h.content_tag(:li, h.content_tag(:span, "&nbsp;".html_safe), :class => "separator")
    end

    links << h.content_tag(:li, h.link_to(title, organization_url), :class => "crumb")

    h.content_tag :ul, links.join("\n").html_safe, :class => "breadcrumbs"
  end

  def suborganizations
    @suborganizations ||= [priority_suborganization] + (Organization.available_suborganization_kinds - [priority_suborganization_kind]).map { |kind| organization.send(kind) }.compact.uniq
  end

  def decorated_suborganizations
    suborganizations.map { |suborganization| "#{suborganization.class.name.underscore}_decorator".classify.constantize.decorate suborganization }
  end

  def categories
    suborganizations.each.map(&:categories).flatten
  end

  def priority_category
    priority_suborganization.categories.first || ''
  end

  def work_schedule
    content = ''
    more_schedule = ''
    from = schedules.pluck(:from).uniq
    to   = schedules.pluck(:to).uniq
    week_day = Time.zone.today.cwday
    content = week_day
    schedule = organization.schedules.find_by_day(week_day)
    if from.size == to.size && from.size == 1
      if from == to
        content = 'Работает круглосуточно'
      else
        content = "Работает ежедневно #{schedule_time(from[0], to[0])}"
      end
    else
      content = "Сегодня <span class='show_more_schedule'>#{schedule_time(schedule.from, schedule.to)}</span>".html_safe
      hash_schedule = {}
      schedules.each do |schedule|
        daily_schedule = schedule_time(schedule.from, schedule.to)
        hash_schedule[daily_schedule] ||= []
        hash_schedule[daily_schedule] << schedule.day
      end
      more_schedule = ""
      hash_schedule.each do |daily_scheule, days|
        more_schedule << h.content_tag(:li, "<span class='days'>#{schedule_day_names(days)}:</span> <span class='hours'>#{daily_scheule}</span>".html_safe)
      end
      more_schedule = h.content_tag(:ul, more_schedule.html_safe, class: :more_schedule)
    end
    h.content_tag(:div, content, :class => "schedule_wrapper work_schedule #{open_closed(schedule.from, schedule.to)}") + more_schedule
  end

  def schedule_content
    content = ""
    schedules.each do |schedule|
      day = h.content_tag(:div, schedule.short_human_day, class: :dow)
      schedule_content = if schedule.holiday?
        h.content_tag(:div, "Выходной".hyphenate, class: :string)
      elsif schedule.from == schedule.to
        h.content_tag(:div, "Круглосуточно".hyphenate, class: :string)
      else
        (h.content_tag(:div, I18n.l(schedule.from, :format => "%H:%M"), class: :from) + h.content_tag(:div, I18n.l(schedule.to, :format => "%H:%M"), class: :to)).html_safe
      end
      content << h.content_tag(:li, (day + schedule_content).html_safe, class: I18n.l(Date.today, :format => '%a') == schedule.short_human_day ? 'today' : nil)
    end
    h.content_tag(:ul, content.html_safe, class: :schedule)
  end

  def schedule_today
    klass = "schedule_today "
    content = "Сегодня "
    wday = Time.zone.today.wday
    wday = 7 if wday == 0
    schedule = organization.schedules.find_by_day(wday)
    if schedule.holiday?
      content << "выходной"
      klass << "closed"
    elsif schedule.from == schedule.to
      content << "работает круглосуточно"
      klass << "twenty_four"
    else
      content << "работает #{schedule_time(schedule.from, schedule.to)}"
      now = Time.zone.now
      time = Time.utc(2000, "jan", 1, now.hour, now.min)
      from = schedule.from
      to = schedule.to
      to = to + 1.day if to.hour < 12
      if time.between?(from, to)
        klass << "opened"
      else
        klass << "closed"
      end
    end
    h.content_tag(:div, content, class: klass) unless content.blank?
  end

  def link_to_priority_category
    h.link_to(priority_category + " Томска ", h.send("#{fake_kind.pluralize}_path", categories: [priority_category.mb_chars.downcase]))
  end

  def category_links
    [].tap do |arr|
      suborganizations.each do |suborganization|
        suborganization.categories.each do |category|

          options = category == I18n.t("organization.list_title.#{suborganization.class.name.underscore}") ? {} : { categories: [category.mb_chars.downcase]}
          arr << Link.new(
            title: category,
            url: h.send("#{suborganization.class.name.underscore.pluralize}_path", options)
          )
        end
      end
    end
  end

  def has_photogallery?
    organization.images.any?
  end

  def has_tour?
    organization.virtual_tour.link?
  end

  def has_affiche?
    actual_affiches_count > 0
  end

  def has_show?
    true
  end

  def stand_info
    res = ""
    if organization_stand && !organization_stand.places.to_i.zero?
      res << I18n.t("organization_stand.places", count: organization_stand.places)
      organization_stand.guarded? ? res << ", охраняется" : res << ", не охраняется"
      organization_stand.video_observation? ? res << ", есть видеонаблюдение" : res << ", без видеонаблюдения"
    end
    res
  end

  def navigation
    links = []
    %w(show photogallery tour affiche).each do |method|
      links << Link.new(
                        title: I18n.t("organization.#{method}"),
                        url: h.send(method == 'show' ? "organization_path" : "#{method}_organization_path"),
                        current: h.controller.action_name == method,
                        disabled: !self.send("has_#{method}?"),
                        kind: method
                       )
    end
    current_index = links.index { |link| link.current? }
    return links unless current_index
    links[current_index - 1].html_options[:class] += ' before_current' if current_index > 0
    links[current_index].html_options[:class] += ' current'
    links
  end

  def tags_for_vk
    res = ""
    res << "<meta property='og:description' content='#{text_description.truncate(350, :separator => ' ')}'/>\n"
    res << "<meta property='og:site_name' content='#{I18n.t('meta.default.title')}' />\n"
    res << "<meta property='og:url' content='#{organization_url}' />\n"
    res << "<meta property='og:title' content='#{title.text_gilensize}' />\n"
    if logotype_url
      image = resized_image_url(logotype_url, 180, 242, false)
      res << "<meta property='og:image' content='#{image}' />\n"
      res << "<meta name='image' content='#{image}' />\n"
      res << "<link rel='image_src' href='#{image}' />\n"
    end
    res.html_safe
  end

  def meta_description
    text_description.truncate(700, :separator => ' ')
  end

  def meta_keywords
    keywords = categories
    suborganizations.each do |suborganization|
      %w[features offers cuisines].each do |field|
        keywords += suborganization.send(field) if suborganization.respond_to?(field) && suborganization.send(field).any?
      end
    end
    keywords.map(&:mb_chars).map(&:downcase).join(',')
  end

  def actual_affiches_count
    HasSearcher.searcher(:showings, organization_ids: [organization.id]).actual.order_by_starts_at.groups.group(:affiche_id_str).total
  end

  def truncated_description
    description.excerpt.hyphenate
  end

  def iconize_info
    content = ''
    if non_cash?
      text = h.content_tag(:span, 'безналичный расчет', class: 'non_cash', title: 'безналичный расчет')
      content << h.content_tag(:li, "#{text}".html_safe)
    end
    h.content_tag :ul, content.html_safe, class: :iconize_info if content.present?
  end

  # FIXME: может быть как-то можно использовать config/initializers/searchers.rb
  # но пока фиг знает как ;(
  def raw_similar_organizations
    lat, lon = organization.latitude, organization.longitude
    radius = 3

    search = priority_suborganization.class.search do
      with(:location).in_radius(lat, lon, radius)
      without(priority_suborganization)

      any_of do
        with("#{fake_kind}_category", categories.map(&:mb_chars).map(&:downcase))
        with("#{fake_kind}_feature", priority_suborganization.features.map(&:mb_chars).map(&:downcase)) if priority_suborganization.respond_to?(:features) && priority_suborganization.features.any?
        with("#{fake_kind}_offer", priority_suborganization.offers.map(&:mb_chars).map(&:downcase)) if priority_suborganization.respond_to?(:offers) && priority_suborganization.offers.any?
        with("#{fake_kind}_cuisine", priority_suborganization.cuisines.map(&:mb_chars).map(&:downcase)) if priority_suborganization.respond_to?(:cuisines) && priority_suborganization.cuisines.any?
      end

      order_by_geodist(:location, lat, lon)
      paginate(page: 1, per_page: 5)
    end

    search.results.map(&:organization)
  end

  def similar_organizations
    OrganizationDecorator.decorate raw_similar_organizations
  end
end
