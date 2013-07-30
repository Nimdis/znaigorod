# encoding: utf-8

class CreationDecorator < SuborganizationDecorator

  decorates :creation

  def viewable?
    services.filled.any?
  end

  def title
    creation.title? ? creation.title : 'Творческие и развивающие направления'
  end

  def htmlise_title_on_show
    h.content_tag :h1, title, :class => 'creation'
  end

  def htmlise_features_on_show
    h.content_tag(:ul, features.map {|f| h.content_tag(:li, f)}.join("\n").html_safe, :class => 'features')
  end

  def characteristics_on_list
    characteristics_by_type("features")
  end

  def grouped_decorated_services
    Hash[services.group_by(&:category)]
  end

end
