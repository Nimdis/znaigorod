# encoding: utf-8

class MealDecorator < SuborganizationDecorator
  decorates :meal

  def viewable?
    meal.cuisines.any? || meal.offers.any? || meal.features.any?
  end

  def characteristics_on_list
    characteristics_by_type("features offers cuisines")
  end

  def characteristics_on_show
    characteristics_by_type("features offers cuisines")
  end

  def title
    meal.title? ? meal.title : categories.first
  end

  def htmlise_cuisines_on_show
    h.content_tag(:ul, cuisines.map {|f| h.content_tag(:li, f)}.join("\n").html_safe, :class => 'cuisines') if cuisines.any?
  end

  def htmlise_offers_and_features_on_show
    content = htmlise_offers_on_show.to_s + htmlise_features_on_show.to_s
    h.content_tag(:ul, content.html_safe, class: :offers_and_features) if content. present?
  end

  def htmlise_offers_on_show
    offers.map {|f| h.content_tag(:li, f)}.join("\n").html_safe if offers.any?
  end

  def htmlise_features_on_show
    features.map {|f| h.content_tag(:li, f)}.join("\n").html_safe if features.any?
  end
end
