# encoding: utf-8

class HotelDecorator < SuborganizationDecorator
  decorates :hotel

  def title
    hotel.title? ? hotel.title : 'Гостиница'
  end

  def htmlise_title_on_show
    h.content_tag :h1, title, :class => 'hotel'
  end

  def htmlise_features_on_show
    features.map {|f| h.content_tag(:li, f)}.join("\n").html_safe if features.any?
  end

  def htmlise_offers_on_show
    offers.map {|f| h.content_tag(:li, f)}.join("\n").html_safe if offers.any?
  end

  def htmlise_offers_and_features_on_show
    content = htmlise_offers_on_show.to_s + htmlise_features_on_show.to_s
    h.content_tag(:ul, content.html_safe, class: :offers_and_features) if content. present?
  end
end
