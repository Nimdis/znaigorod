# encoding: utf-8

class AfficheDecorator < ApplicationDecorator
  include AutoHtmlFor
  decorates :affiche

  delegate :distribution_starts_on, :distribution_ends_on, :distribution_starts_on?, :distribution_ends_on?, :kind, :to => :affiche
  attr_accessor :showings

  def initialize(affiche, showings = nil)
    super
    @showings = showings ? ShowingDecorator.decorate(showings) : ShowingDecorator.decorate(affiche.showings.actual)
  end

  def main_page_link
    truncated_link(45)
  end

  def posters_title_link
    truncated_link(23, nil, nil)
  end

  def has_ribbon
    h.content_tag(:div, h.content_tag(:div, "Премьера недели", class: :ribbon), class: :ribbon_wrapper) if affiche.premiere?
  end

  def geo_present?
    places.any? && !places.first.latitude.blank? && !places.first.longitude.blank?
  end

  auto_html_for :trailer_code do
    youtube(:width => 740, :height => 450)
    vimeo(:width => 740, :height => 450)
  end

  def kind_affiche_path(options = {})
    h.send "#{kind}_path", affiche, options
  end

  def kind_affiche_url(options = {})
    h.send "#{kind}_url", affiche, options
  end

  def kind_affiche_photogallery_path(options = {})
    h.send "#{kind}_path", affiche, options.merge({:anchor => 'photogallery'})
  end

  def kind_affiche_trailer_path(options = {})
    h.send "#{kind}_path", affiche, options.merge({:anchor => 'trailer'})
  end

  def all_affiches_link
    h.link_to "Все #{human_kind.mb_chars.downcase} (#{counter.all})", h.affiches_path(categories: [kind])
  end

  def breadcrumbs
    links = []
    links << h.content_tag(:li, h.link_to("Знай\u00ADГород", h.root_path), :class => "crumb")
    links << h.content_tag(:li, h.content_tag(:span, "&nbsp;".html_safe), :class => "separator")
    links << h.content_tag(:li, h.link_to("Вся афиша Томска", h.affiches_path), :class => "crumb")
    links << h.content_tag(:li, h.content_tag(:span, "&nbsp;".html_safe), :class => "separator")
    links << h.content_tag(:li, h.link_to("Все #{human_kind.mb_chars.downcase} в Томске", h.affiches_path('categories[]' => kind)), :class => "crumb")
    links << h.content_tag(:li, h.content_tag(:span, "&nbsp;".html_safe), :class => "separator")
    links << h.content_tag(:li, h.link_to(title, kind_affiche_path), :class => "crumb")
    %w(photogallery trailer).each do |method|
      if h.controller.action_name == method
        links << h.content_tag(:li, h.content_tag(:span, "&nbsp;".html_safe), :class => "separator")
        links << h.content_tag(:li, h.link_to(navigation_title(method), self.send("kind_affiche_#{method}_path")), :class => "crumb")
      end
    end
    h.content_tag :ul, links.join("\n").html_safe, :class => "breadcrumbs"
  end

  def link
    h.link_to affiche.title.text_gilensize, kind_affiche_path
  end

  def title_link
    link
  end

  def show_url
    kind_affiche_path
  end

  def more_link
    h.link_to "Подробнее...", kind_affiche_path, :title => affiche.title
  end

  def schedule
    AfficheScheduleDecorator.decorate affiche.affiche_schedule
  end

  def has_show?
    true
  end

  def has_photogallery?
    affiche.has_images?
  end

  def has_trailer?
    affiche.trailer_code?
  end

  def navigation_title(method)
    case method
    when 'show'
      "Описание"
    when 'photogallery'
      affiche.is_a?(Movie) ? "Кадры" : "Фотографии"
    when 'trailer'
      affiche.is_a?(Movie) ? "Трейлер" : "Видео"
    end
  end

  def navigation
    links = []
    %w(show photogallery trailer).each do |method|
      links << Link.new(
                        title: navigation_title(method),
                        url: method == 'show' ? self.send("kind_affiche_path") : self.send("kind_affiche_#{method}_path"),
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

  def affiche_place(length = 45, separator = ' ')
    max_lenght = length
    place_output = ""
    places.each_with_index do |place, index|
      place_title = place.organization ? place.organization.title : place.title
      place_link_title = place_title.dup
      place_title = place_title.gsub(/,.*/, '')
      place_title = place_title.truncate(max_lenght, :separator => separator)
      max_lenght -= place_title.size
      if place.organization
        place_output += h.link_to place_title.text_gilensize.hyphenate, OrganizationDecorator.decorate(place.organization).organization_url, :title => place_link_title.text_gilensize
      else
        place_output += place_link_title.blank? ? place_title.text_gilensize.hyphenate : h.content_tag(:abbr, place_title.text_gilensize.hyphenate, :title => place_link_title.text_gilensize)
      end
      break if max_lenght < 3
      place_output += ", " if index < places.size - 1
    end
    h.raw place_output
  end

  def main_page_place
    affiche_place
  end

  def posters_place
    affiche_place(22, nil)
  end

  def places
    [].tap do |array|
      if showings.any?
        showings.map { |showing| showing.organization ? showing.organization : showing.place }.uniq.each do |place|
          array << (place.is_a?(Organization) ? PlaceDecorator.new(:organization => place) : PlaceDecorator.new(:title => place,
                                                                       :latitude => affiche.showings.where(:place => place).first.latitude,
                                                                       :longitude => affiche.showings.where(:place => place).first.longitude))
        end
      else
        last_showoing = affiche.showings.last
        return [] unless last_showoing
        place = last_showoing.organization ? last_showoing.organization : last_showoing.place
        array << (place.is_a?(Organization) ? PlaceDecorator.new(:organization => place) : PlaceDecorator.new(:title => place,
                                                                                   :latitude => last_showoing.latitude,
                                                                                   :longitude => last_showoing.longitude))
      end
    end
  end

  def truncated_description
    description.to_s.excerpt.hyphenate
  end

  def html_attachments
    return "" if gallery_files.blank?
    links = []
    gallery_files.each do |attachment|
      links << h.content_tag(:li, h.link_to(attachment.description, attachment.file_url))
    end
    h.content_tag :ul, links.join("\n").html_safe
  end

  def main_page_poster
    poster_with_link affiche, 200, 268
  end

  def posters_list_poster
    poster_with_link affiche, 170, 228
  end

  def resized_poster_url(width, height, crop)
    return unless affiche.poster_url.present?
    h.resized_image_url(affiche.poster_url, width, height, crop)
  end

  def meta_description
    description.to_s.truncate(200, separator: ' ')
  end

  def meta_keywords
    [human_kind, affiche.tags, raw_places].flatten.map(&:mb_chars).map(&:downcase).join(', ')
  end

  def tags_for_vk
    desc = ""
    desc << when_with_price
    desc << " "
    desc << main_page_place
    desc << ". "
    desc << html_description
    desc = desc.gsub(/<table>.*<\/table>/m, '').gsub(/<\/?\w+.*?>/m, '').gsub(' ,', ',').squish.html_safe
    image = resized_image_url(poster_url, 180, 242, false)
    res = ""
    res << "<meta property='og:description' content='#{desc.truncate(350, :separator => ' ').html_safe}'/>\n"
    res << "<meta property='og:site_name' content='#{I18n.t('meta.default.title')}' />\n"
    res << "<meta property='og:title' content='#{title.to_s.text_gilensize}' />\n"
    res << "<meta property='og:url' content='#{kind_affiche_url}' />\n"
    res << "<meta property='og:image' content='#{image}' />\n"
    res << "<meta name='image' content='#{image}' />\n"
    res << "<link rel='image_src' href='#{image}' />\n"
    res.html_safe
  end

  def raw_places
    showings.with_organization.map(&:organization).uniq.map(&:title).map { |t| t.split(',').join(' ') }
  end

  def list_poster
    poster_with_link affiche, 180, 242
  end

  def item_poster
    h.link_to poster(affiche, 180, 242), affiche.poster_url, class: :poster
  end

  def more_like_this_poster
    poster_with_link affiche, 150, 202
  end

  def affiche_distribution?
    affiche.distribution_starts_on? || affiche.distribution_ends_on? || affiche.constant?
  end

  def affiche_actual?
    affiche.showings.actual.count > 0
  end

  def viewable_showings?
    return false if (affiche.is_a?(Other) || affiche.is_a?(SportsEvent)) && affiche_distribution?
    affiche_actual? && other_showings.any?
  end

  def distribution_movie?
    affiche.is_a?(Movie) && affiche_distribution?
  end

  def scheduled_showings?
    affiche.affiche_schedule && affiche_distribution? && (affiche.is_a?(Exhibition) || affiche.is_a?(MasterClass))
  end

  def human_when
    nealest_showing = showings.any? ? showings.first : ShowingDecorator.new(affiche.showings.last)
    return "Время проведения неизвестно" unless nealest_showing.showing
    if affiche_actual?
      if affiche.constant?
        case affiche.class.name
        when 'Exhibition'
          return "Постоянная экспозиция"
        else
          return "Постоянное мероприятие"
        end
      end
      return human_distribution if affiche_distribution?
    else
      case affiche.class.name
      when 'Movie'
        if affiche_distribution?
          return human_distribution if affiche.distribution_starts_on >= Date.today
          return "Было в прокате до #{nealest_showing.e_B(nealest_showing.starts_at)}"
        else
          return "Последний показ был #{nealest_showing.e_B(nealest_showing.starts_at)}"
        end
      when 'Exhibition'
        return "Выставка закончилась #{nealest_showing.e_B(nealest_showing.starts_at)}"
      end
    end
    nealest_showing.actual? ? nealest_showing.human_when : "Было #{nealest_showing.e_B(nealest_showing.starts_at)}"
  end

  def human_price
    humanize_price(showings.map(&:price_min).uniq.compact.min, showings.map(&:price_max).uniq.compact.max)
  end

  def when_with_price
    if showings.any?
      h.content_tag :p, h.content_tag(:span, human_when, :class => :when ) + ", " + h.content_tag(:span, human_price, :class => :price).html_safe
    else
      h.content_tag :p, h.content_tag(:span, human_when, :class => :when )
    end
  end

  def human_distribution
    if distribution_starts_on? && distribution_ends_on?
      return "С #{distribution_starts_on.day} по #{I18n.l(distribution_ends_on, :format => '%e %B')}".squish if  distribution_starts_on.month == distribution_ends_on.month
      return "С #{I18n.l(distribution_starts_on, :format => '%e %B')} по #{I18n.l(distribution_ends_on, :format => '%e %B')}".squish
    elsif distribution_starts_on?
      return "С #{I18n.l(distribution_starts_on, :format => '%e %B')}".squish
    elsif distribution_ends_on?
      return "До #{I18n.l(distribution_ends_on, :format => '%e %B')}".squish
    end
  end

  def pluralized_kind
    kind.pluralize
  end

  def human_kind
    I18n.t("activerecord.models.#{kind}")
  end

  def other_showings
    return [] unless affiche_actual?
    first_showing = showings.first
    @other_showings ||= if first_showing && first_showing.actual?
                          if affiche_distribution?
                            ShowingDecorator.decorate affiche.showings.where("starts_at >= ?", showings.first.starts_at)
                          else
                            ShowingDecorator.decorate affiche.showings.where("starts_at > ?", showings.first.starts_at)
                          end
                        else
                          ShowingDecorator.decorate affiche.showings.where("starts_at > ?", DateTime.now.beginning_of_day)
                        end
  end

  def first_other_showing_today?
    ShowingDecorator.decorate(other_showings.first).today?
  end

  def other_showings_size
    other_showings.count - 2
  end

  def html_many_other_showings
    h.link_to("и еще #{other_showings_size}", kind_affiche_path(:anchor => "showings")) if other_showings_size > 0
  end

  def html_other_showings
    ((other_showings[0..1].map(&:html_other_showing)).compact.join(", <br />") + "&nbsp;" + html_many_other_showings.to_s).html_safe
  end

  def distribution_movie_nearlest_grouped_showings
    other_showings.any? ? other_showings.group_by(&:starts_on).first.second.group_by(&:place) : []
  end

  def distribution_movie_grouped_showings
    {}.tap do |hash|
      showings.group_by(&:starts_on).each do |date, showings|
        hash[date] = showings.select(&:actual?).group_by(&:place)
      end
    end
  end

  def distribution_movie_schedule_date
    "Ближайшие сеансы #{other_showings.first.human_date.mb_chars.downcase}" if other_showings.any?
  end

  def similar_affiches
    searcher.more_like_this(affiche).limit(2).results.map { |a| AfficheDecorator.new a }
  end

  def similar_affiches_with_images
    searcher.more_like_this(affiche).with_images.limit(2).results.map { |a| AfficheDecorator.new a }
  end

  def trailer
    return "" if trailer_code.blank?
    trailer_code.html_safe
  end

  private

  def truncated_link(length, anchor = nil, separator = ' ')
    h.link_to affiche.title.text_gilensize.truncated(length, separator), kind_affiche_path(anchor: anchor), :title => affiche.title
  end

  def in_one_day?
    distribution_starts_on == distribution_ends_on
  end

  def poster_with_link(affiche, width, height)
    h.link_to poster(affiche, width, height), kind_affiche_path
  end

  def poster(affiche, width, height)
    return unless affiche.poster_url.present?

    if affiche.poster_url =~ /region/
      h.image_tag affiche.poster_url, :size => "#{width}x#{height}"
    else
      image_tag(affiche.poster_url, width, height, affiche.title.to_s.text_gilensize)
    end
  end

  def searcher
    HasSearcher.searcher(:similar_affiches)
  end

  def counter
    Counter.new(:category => kind)
  end
end
