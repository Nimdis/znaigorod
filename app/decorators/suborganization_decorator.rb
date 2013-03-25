# encoding: utf-8

class SuborganizationDecorator < ApplicationDecorator
  def decorated_organization
    OrganizationDecorator.decorate organization
  end

  delegate :logo_link, :title_link, :address_link, :html_description,
    :truncated_description, :site_link, :email_link, :stand_info, :schedule_today,
    :to => :decorated_organization

  def decorated_title
    h.content_tag :h3, title, class: :suborganization if title?
  end

  def viewable?
    false
  end

  def iconize_info
    content = ''
    if description.present?
      link = h.link_to('информация', '#', :class => :description_icon, :'data-link' => :description_text)
      text = h.content_tag(:div, description.as_html, :class => :description_text)
      content << h.content_tag(:li, "#{link}\n#{text}".html_safe)
    end
    h.content_tag :ul, content.html_safe, class: :iconize_info if content.present?
  end

  def contacts
    content = []
    content << phone.squish unless phone.blank?
    content << email_link unless email_link.blank?
    content << site_link unless site_link.blank?
    h.content_tag(:div, content.join(", ").html_safe, class: :contacts) unless content.blank?
  end

  def categories
    model.organization.suborganizations.flat_map(&:categories).map(&:mb_chars).sort
  end

  def snipped_links
    links = []
    %w(photogallery tour affiche).each do |method|
      links << Link.new(
        title: I18n.t("organization.#{method}"),
        url: h.send("#{method}_organization_path", organization)
      ) if self.decorated_organization.send("has_#{method}?")
    end
    return "" if links.empty?
    h.content_tag :ul, links.map {|l| h.content_tag :li, l.to_s}.join("\n").html_safe, class: :snipped_links
  end

  def decorated_description
    h.content_tag(:div, description.as_html, class: :description) if description?
  end

  def list_of_characteristics(name)
    content = ""
    content << h.content_tag(:li, I18n.t("activerecord.attributes.#{self.decorate.model.class.name.downcase}.#{name.singularize}"), class: "title")
    content << "\n"
    # FIXME: грязный хак ;(
    organization_class = [Billiard, Sauna].include?(self.decorate.model.class) ? 'entertainments' : self.decorate.model.class.name.downcase.pluralize
    self.send(name).each do |value|
      content << h.content_tag(:li, h.link_to(value, h.organizations_path(organization_class: organization_class,
                                                                          category: priority_category,
                                                                          query: "#{name}/#{value.mb_chars.downcase}")))
      content << "\n"
    end
    h.content_tag(:ul, content.html_safe)
  end

  def characteristics_by_type(types)
    result = types.split.map { |characteristic| list_of_characteristics(characteristic) if self.send(characteristic).any? }.join("\n")
    h.content_tag :div, result.html_safe, class: "characteristics" unless result.blank?
  end

  def priority_category
    categories.first.mb_chars.downcase
  end

  def htmlize_text(text)
    text.blank? ? "" : text.as_html
  end

  def has_photogallery?
    images.any?
  end

end
