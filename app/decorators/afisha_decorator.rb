# encoding: utf-8

class AfishaDecorator < ApplicationDecorator
  include AutoHtmlFor
  decorates :afisha

  delegate :distribution_starts_on, :distribution_ends_on, :distribution_starts_on?, :distribution_ends_on?, :kind, :to => :afisha

  attr_accessor :showings

  def initialize(afisha, showings = nil)
    super
    @showings = showings ? ShowingDecorator.decorate(showings) : ShowingDecorator.decorate(afisha.showings.actual)
  end

  def truncated_title_link(length, options = { separator: ' ', anchor: nil })
    if afisha.title.length > length
      h.link_to(afisha.title.text_gilensize.truncated(length, options[:separator]), h.afisha_show_path(afisha, anchor: options[:anchor]), :title => afisha.title)
    else
      h.link_to(afisha.title.text_gilensize, h.afisha_show_path(afisha, anchor: options[:anchor]))
    end
  end

  def poster_with_link(width, height)
    h.link_to h.afisha_show_path(afisha) do
      h.image_tag(h.resized_image_url(afisha.poster_url, width, height, { crop: '!', orientation: 'n' }), size: "#{width}x#{height}", alt: afisha.title)
    end
  end

  def afisha_place(length = 45, separator = ' ')
    max_lenght = length
    place_output = ""
    places.each_with_index do |place, index|
      place_title = place.organization ? place.organization.title : place.title
      place_link_title = place_title.dup
      place_title = place_title.gsub(/,.*/, '')
      place_title = place_title.truncate(max_lenght, :separator => separator)
      max_lenght -= place_title.size
      if place.organization
        place_output += h.link_to place_title.text_gilensize, place.organization, :title => place_link_title.text_gilensize
      else
        place_output += place_link_title.blank? ? place_title.text_gilensize : h.content_tag(:abbr, place_title.text_gilensize, :title => place_link_title.text_gilensize)
      end
      break if max_lenght < 3
      place_output += ", " if index < places.size - 1
    end
    h.raw place_output
  end

  def places
    [].tap do |array|
      if showings.any?
        showings.map { |showing| showing.organization ? showing.organization : showing.place }.uniq.each do |place|
          array << (place.is_a?(Organization) ? PlaceDecorator.new(:organization => place) : PlaceDecorator.new(:title => place,
                                                                       :latitude => afisha.showings.where(:place => place).first.latitude,
                                                                       :longitude => afisha.showings.where(:place => place).first.longitude))
        end
      else
        last_showoing = afisha.showings.last
        return [] unless last_showoing
        place = last_showoing.organization ? last_showoing.organization : last_showoing.place
        array << (place.is_a?(Organization) ? PlaceDecorator.new(:organization => place) : PlaceDecorator.new(:title => place,
                                                                                   :latitude => last_showoing.latitude,
                                                                                   :longitude => last_showoing.longitude))
      end
    end
  end

  #def show_url
    #h.afisha_show_path(afisha)
  #end

  #def title_link
    #afisha.title
  #end

  #def main_page_link
    #truncated_link(45)
  #end

  #def posters_title_link
    #truncated_link(23, nil, nil)
  #end

  #def has_ribbon
    #h.content_tag(:div, h.content_tag(:div, "Премьера недели", class: :ribbon), class: :ribbon_wrapper) if afisha.premiere?
  #end

  #def geo_present?
    #places.any? && !places.first.latitude.blank? && !places.first.longitude.blank?
  #end

  #auto_html_for :trailer_code do
    #youtube(:width => 740, :height => 450)
    #vimeo(:width => 740, :height => 450)
  #end

  #def kind_afisha_path(options = {})
    #h.send "afisha_path", afisha, options
  #end

  #def kind_afisha_url(options = {})
    #h.send "afisha_url", afisha, options
  #end

  #def kind_afisha_photogallery_path(options = {})
    #h.send "afisha_show_path", afisha, options.merge({:anchor => 'photogallery'})
  #end

  #def kind_afisha_trailer_path(options = {})
    #h.send "afisha_show_path", afisha, options.merge({:anchor => 'trailer'})
  #end

  #def all_afisha_link
    #h.link_to "Все #{kind.map(&:text).join(', ')} (#{counter.all})", h.afisha_index_path(afisha, categories: [kind])
  #end

  #def breadcrumbs
    #links = []
    #links << h.content_tag(:li, h.link_to("Знай\u00ADГород", h.root_path), :class => "crumb")
    #links << h.content_tag(:li, h.content_tag(:span, "&nbsp;".html_safe), :class => "separator")
    #links << h.content_tag(:li, h.link_to("Вся афиша Томска", h.afisha_index_path), :class => "crumb")
    #links << h.content_tag(:li, h.content_tag(:span, "&nbsp;".html_safe), :class => "separator")
    #links << h.content_tag(:li, h.link_to("Все #{kind.map(&:text).join(', ')} в Томске", h.afisha_index_path('categories[]' => kind)), :class => "crumb")
    #links << h.content_tag(:li, h.content_tag(:span, "&nbsp;".html_safe), :class => "separator")
    #links << h.content_tag(:li, h.link_to(title, h.afisha_show_path(afisha)), :class => "crumb")
    #%w(photogallery trailer).each do |method|
      #if h.controller.action_name == method
        #links << h.content_tag(:li, h.content_tag(:span, "&nbsp;".html_safe), :class => "separator")
        #links << h.content_tag(:li, h.link_to(navigation_title(method), self.send("afisha_#{method}_path")), :class => "crumb")
      #end
    #end
    #h.content_tag :ul, links.join("\n").html_safe, :class => "breadcrumbs"
  #end

  #def schedule
    #AfficheScheduleDecorator.decorate afisha.affiche_schedule
  #end

  #def has_photogallery?
    #afisha.has_images?
  #end

  #def has_trailer?
    #afisha.trailer_code?
  #end

  #def navigation_title(method)
    #case method
    #when 'show'
      #"Описание"
    #when 'photogallery'
      #afisha.movie? ? "Кадры" : "Фотографии"
    #when 'trailer'
      #afisha.movie? ? "Трейлер" : "Видео"
    #end
  #end

  #def navigation
    #links = []
    #%w(show photogallery trailer).each do |method|
      #links << Link.new(
                        #title: navigation_title(method),
                        #url: method == 'show' ? self.send("afisha_path") : self.send("afisha_#{method}_path"),
                        #current: h.controller.action_name == method,
                        #disabled: !self.send("has_#{method}?"),
                        #kind: method
                       #)
    #end
    #current_index = links.index { |link| link.current? }
    #return links unless current_index
    #links[current_index - 1].html_options[:class] += ' before_current' if current_index > 0
    #links[current_index].html_options[:class] += ' current'
    #links
  #end

  #def afisha_place(length = 45, separator = ' ')
    #max_lenght = length
    #place_output = ""
    #places.each_with_index do |place, index|
      #place_title = place.organization ? place.organization.title : place.title
      #place_link_title = place_title.dup
      #place_title = place_title.gsub(/,.*/, '')
      #place_title = place_title.truncate(max_lenght, :separator => separator)
      #max_lenght -= place_title.size
      #if place.organization
        #place_output += h.link_to place_title.text_gilensize.hyphenate, OrganizationDecorator.decorate(place.organization).organization_url, :title => place_link_title.text_gilensize
      #else
        #place_output += place_link_title.blank? ? place_title.text_gilensize.hyphenate : h.content_tag(:abbr, place_title.text_gilensize.hyphenate, :title => place_link_title.text_gilensize)
      #end
      #break if max_lenght < 3
      #place_output += ", " if index < places.size - 1
    #end
    #h.raw place_output
  #end

  #def main_page_place
    #afisha_place
  #end

  #def posters_place
    #afisha_place(22, nil)
  #end

  #def truncated_description
    #description.to_s.excerpt.hyphenate
  #end

  #def html_attachments
    #return "" if gallery_files.blank?
    #links = []
    #gallery_files.each do |attachment|
      #links << h.content_tag(:li, h.link_to(attachment.description, attachment.file_url))
    #end
    #h.content_tag :ul, links.join("\n").html_safe
  #end

  #def main_page_poster
    #poster_with_link afisha, 200, 268
  #end

  #def posters_list_poster
    #poster_with_link afisha, 170, 228
  #end

  #def resized_poster_url(width, height, crop)
    #return unless afisha.poster_url.present?
    #h.resized_image_url(afisha.poster_url, width, height, crop)
  #end

  #def meta_description
    #description.to_s.truncate(200, separator: ' ')
  #end

  #def meta_keywords
    #[kind.map(&:text).join(', '), afisha.tags, raw_places].flatten.map(&:mb_chars).map(&:downcase).join(', ')
  #end

  #def tags_for_vk
    #desc = ""
    #desc << when_with_price
    #desc << " "
    #desc << main_page_place
    #desc << ". "
    #desc << html_description
    #desc = desc.gsub(/<table>.*<\/table>/m, '').gsub(/<\/?\w+.*?>/m, '').gsub(' ,', ',').squish.html_safe
    #image = resized_image_url(poster_url, 180, 242, false)
    #res = ""
    #res << "<meta property='og:description' content='#{desc.truncate(350, :separator => ' ').html_safe}'/>\n"
    #res << "<meta property='og:site_name' content='#{I18n.t('meta.default.title')}' />\n"
    #res << "<meta property='og:title' content='#{title.to_s.text_gilensize}' />\n"
    #res << "<meta property='og:url' content='#{h.afisha_show_url(afisha)}' />\n"
    #res << "<meta property='og:image' content='#{image}' />\n"
    #res << "<meta name='image' content='#{image}' />\n"
    #res << "<link rel='image_src' href='#{image}' />\n"
    #res.html_safe
  #end

  #def raw_places
    #showings.with_organization.map(&:organization).uniq.map(&:title).map { |t| t.split(',').join(' ') }
  #end

  #def list_poster
    #poster_with_link afisha, 180, 242
  #end

  #def item_poster
    #h.link_to poster(afisha, 180, 242), afisha.poster_url, class: :poster
  #end

  #def more_like_this_poster
    #poster_with_link afisha, 150, 202
  #end

  #def afisha_distribution?
    #afisha.distribution_starts_on? || afisha.distribution_ends_on? || afisha.constant?
  #end

  #def afisha_actual?
    #afisha.showings.actual.count > 0
  #end

  #def viewable_showings?
    #return false if (afisha.other? || afisha.sportsevent?) && afisha_distribution?
    #afisha_actual? && other_showings.any?
  #end

  #def distribution_movie?
    #afisha.movie? && afisha_distribution?
  #end

  #def scheduled_showings?
    #afisha.affiche_schedule && afisha_distribution? && (afisha.exhibition? || afisha.masterclass?)
  #end

  #def human_when
    #nealest_showing = showings.any? ? showings.first : ShowingDecorator.new(afisha.showings.last)
    #return "Время проведения неизвестно" unless nealest_showing.showing
    #if afisha_actual?
      #if afisha.constant?
        #afisha.exhibition? ? 'Постоянная экспозиция' : 'Постоянное мероприятие'
      #end
      #return human_distribution if afisha_distribution?
    #else
      #case afisha.kind
      #when 'movie'
        #if afisha_distribution?
          #return human_distribution if afisha.distribution_starts_on >= Date.today
          #return "Было в прокате до #{nealest_showing.e_B(nealest_showing.starts_at)}"
        #else
          #return "Последний показ был #{nealest_showing.e_B(nealest_showing.starts_at)}"
        #end
      #when 'exhibition'
        #return "Выставка закончилась #{nealest_showing.e_B(nealest_showing.starts_at)}"
      #end
    #end
    #nealest_showing.actual? ? nealest_showing.human_when : "Было #{nealest_showing.e_B(nealest_showing.starts_at)}"
  #end

  #def human_price
    #humanize_price(showings.map(&:price_min).uniq.compact.min, showings.map(&:price_max).uniq.compact.max)
  #end

  #def when_with_price
    #if showings.any?
      #h.content_tag :p, h.content_tag(:span, human_when, :class => :when ) + ", " + h.content_tag(:span, human_price, :class => :price).html_safe
    #else
      #h.content_tag :p, h.content_tag(:span, human_when, :class => :when )
    #end
  #end

  #def human_distribution
    #if distribution_starts_on? && distribution_ends_on?
      #return "С #{distribution_starts_on.day} по #{I18n.l(distribution_ends_on, :format => '%e %B')}".squish if  distribution_starts_on.month == distribution_ends_on.month
      #return "С #{I18n.l(distribution_starts_on, :format => '%e %B')} по #{I18n.l(distribution_ends_on, :format => '%e %B')}".squish
    #elsif distribution_starts_on?
      #return "С #{I18n.l(distribution_starts_on, :format => '%e %B')}".squish
    #elsif distribution_ends_on?
      #return "До #{I18n.l(distribution_ends_on, :format => '%e %B')}".squish
    #end
  #end

  #def pluralized_kind
    #kind.pluralize
  #end

  #def other_showings
    #return [] unless afisha_actual?
    #first_showing = showings.first
    #@other_showings ||= if first_showing && first_showing.actual?
                          #if afisha_distribution?
                            #ShowingDecorator.decorate afisha.showings.where("starts_at >= ?", showings.first.starts_at)
                          #else
                            #ShowingDecorator.decorate afisha.showings.where("starts_at > ?", showings.first.starts_at)
                          #end
                        #else
                          #ShowingDecorator.decorate afisha.showings.where("starts_at > ?", DateTime.now.beginning_of_day)
                        #end
  #end

  #def first_other_showing_today?
    #ShowingDecorator.decorate(other_showings.first).today?
  #end

  #def other_showings_size
    #other_showings.count - 2
  #end

  #def html_many_other_showings
    #h.link_to("и еще #{other_showings_size}", affisha_path(:anchor => "showings")) if other_showings_size > 0
  #end

  #def html_other_showings
    #((other_showings[0..1].map(&:html_other_showing)).compact.join(", <br />") + "&nbsp;" + html_many_other_showings.to_s).html_safe
  #end

  #def distribution_movie_nearlest_grouped_showings
    #other_showings.any? ? other_showings.group_by(&:starts_on).first.second.group_by(&:place) : []
  #end

  #def distribution_movie_grouped_showings
    #{}.tap do |hash|
      #showings.group_by(&:starts_on).each do |date, showings|
        #hash[date] = showings.select(&:actual?).group_by(&:place)
      #end
    #end
  #end

  #def distribution_movie_schedule_date
    #"Ближайшие сеансы #{other_showings.first.human_date.mb_chars.downcase}" if other_showings.any?
  #end

  #def similar_afisha
    #searcher.more_like_this(afisha).limit(2).results.map { |a| AfishaDecorator.new a }
  #end

  #def similar_afisha_with_images
    #searcher.more_like_this(afisha).with_images.limit(2).results.map { |a| AfishaDecorator.new a }
  #end

  #def trailer
    #trailer_code.to_s.html_safe
  #end

  #private

  #def in_one_day?
    #distribution_starts_on == distribution_ends_on
  #end

  #def poster_with_link(afisha, width, height)
    #h.link_to poster(afisha, width, height), h.afisha_show_path(afisha)
  #end

  #def poster(afisha, width, height)
    #return unless afisha.poster_url.present?

    #if afisha.poster_url =~ /region/
      #h.image_tag afisha.poster_url, :size => "#{width}x#{height}"
    #else
      #image_tag(afisha.poster_url, width, height, afisha.title.to_s.text_gilensize)
    #end
  #end

  #def searcher
    #HasSearcher.searcher(:similar_affiches)
  #end

  #def counter
    #Counter.new(:category => kind)
  #end
end
