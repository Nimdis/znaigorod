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
        showings.compact.map { |showing| showing.organization ? showing.organization : showing.place }.uniq.each do |place|
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

  def afisha_distribution?
    afisha.distribution_starts_on? || afisha.distribution_ends_on? || afisha.constant?
  end

  def afisha_actual?
    afisha.showings.actual.count > 0
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

  def human_when
    nealest_showing = showings.any? ? showings.first : ShowingDecorator.new(afisha.showings.last)
    return "Время проведения неизвестно" unless nealest_showing.showing
    if afisha_actual?
      if afisha.constant?
        return afisha.exhibition? ? 'Постоянная экспозиция' : 'Постоянное мероприятие'
      end
      return human_distribution if afisha_distribution?
    else
      case afisha.kind
      when *['movie']
        if afisha_distribution?
          return human_distribution if afisha.distribution_starts_on >= Date.today
          return "Было в прокате до #{nealest_showing.e_B(nealest_showing.starts_at)}"
        else
          return "Последний показ был #{nealest_showing.e_B(nealest_showing.starts_at)}"
        end
      when *['exhibition']
        return "Выставка закончилась #{nealest_showing.e_B(nealest_showing.starts_at)}"
      end
    end
    nealest_showing.actual? ? nealest_showing.human_when : "Было #{nealest_showing.e_B(nealest_showing.starts_at)}"
  end

  def meta_keywords
    [kind.map(&:text).join(', '), afisha.tags].flatten.map(&:mb_chars).map(&:downcase).join(', ')
  end

  def meta_description
    description.to_s.truncate(200, separator: ' ')
  end

  def tags_for_vk
    desc = ""
    desc << when_with_price
    desc << " "
    desc << h.link_to(afisha.title.text_gilensize.truncated, h.afisha_show_path(afisha), :title => afisha.title)
    desc << ". "
    desc << html_description
    desc = desc.without_table.gsub(/<\/?\w+.*?>/m, '').gsub(' ,', ',').squish.html_safe
    image = h.resized_image_url(poster_url, 180, 242)
    res = ""
    res << "<meta property='og:description' content='#{desc.truncate(350, :separator => ' ').html_safe}'/>\n"
    res << "<meta property='og:site_name' content='#{I18n.t('meta.default.title')}' />\n"
    res << "<meta property='og:title' content='#{title.to_s.text_gilensize}' />\n"
    res << "<meta property='og:url' content='#{h.afisha_show_url(afisha)}' />\n"
    res << "<meta property='og:image' content='#{image}' />\n"
    res << "<meta name='image' content='#{image}' />\n"
    res << "<link rel='image_src' href='#{image}' />\n"
    res.html_safe
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

  def distribution_movie?
    afisha.movie? && afisha_distribution?
  end

  def html_attachments
    return "" if gallery_files.blank?
    links = []
    gallery_files.each do |attachment|
      links << h.content_tag(:li, h.link_to(attachment.description, attachment.file_url))
    end
    h.content_tag :ul, links.join("\n").html_safe
  end

  def viewable_showings?
    return false if (afisha.other? || afisha.sportsevent?) && afisha_distribution?
    afisha_actual? && other_showings.any?
  end

  def other_showings
    return [] unless afisha_actual?
    first_showing = showings.first
    @other_showings ||= if first_showing && first_showing.actual?
                          if afisha_distribution?
                            ShowingDecorator.decorate afisha.showings.where("starts_at >= ?", showings.first.starts_at)
                          else
                            ShowingDecorator.decorate afisha.showings.where("starts_at > ?", showings.first.starts_at)
                          end
                        else
                          ShowingDecorator.decorate afisha.showings.where("starts_at > ?", DateTime.now.beginning_of_day)
                        end
  end

  def scheduled_showings?
    afisha.affiche_schedule && afisha_distribution? && (afisha.exhibition? || afisha.masterclass?)
  end

  def schedule
    AfficheScheduleDecorator.decorate afisha.affiche_schedule
  end

  def geo_present?
    places.any? && !places.first.latitude.blank? && !places.first.longitude.blank?
  end

  def similar_afisha
    count = geo_present? ? 3 : 5
    searcher.more_like_this(afisha).limit(count).results.map { |a| AfishaDecorator.new a }
  end

  def searcher
    HasSearcher.searcher(:similar_afisha)
  end

  auto_html_for :trailer_code do
    youtube(:width => 240, :height => 146)
    vimeo(:width => 240, :height => 146)
    link :target => '_blank'
    double_enter
    simple_format
  end

  auto_html_for :description do
    link :target => '_blank', :rel => 'nofollow'
  end

  def distribution_movie_grouped_showings
    {}.tap do |hash|
      showings.group_by(&:starts_on).each do |date, showings|
        hash[date] = showings.select(&:actual?).group_by(&:place)
      end
    end
  end

  # for popular api
  def resized_image_url(url, width, height, options = { :crop => '!', :magnify => 'm', :orientation => 'n' })
    return if url.blank?
    if url.match(/\d+\/region\/\d+/)
      return url.gsub(/(\/files\/\d+\/region\/(\d+|\/){8})/) { "#{$1}#{width}-#{height}/" }
    end
    if url.match(/\/files\/\d+\/\d+-\d+\//)
      image_url, image_id, image_width, image_height, image_crop, image_filename = url.match(%r{(.*)/files/(\d+)/(?:(\d+)-(\d+)(\!)?/)?(.*)})[1..-1]
      return "#{image_url}/files/#{image_id}/#{width}-#{height}#{options[:crop]}#{options[:magnify]}#{options[:orientation]}/#{image_filename}"
    end
    url
  end
end
