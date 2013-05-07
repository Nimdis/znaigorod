# encoding: utf-8

class PlaceDecorator
  include Rails.application.routes.url_helpers
  include ActiveAttr::MassAssignment
  include ActionView::Helpers
  include ActiveAttr::QueryAttributes
  attr_accessor :latitude, :longitude, :title
  attribute :organization

  def initialize(params)
    super
    if organization
      self.latitude ||= organization.latitude
      self.longitude ||= organization.longitude
      self.title ||= organization.title
      self.organization = OrganizationDecorator.decorate organization
    end
  end

  def place
    return content_tag(:p, content_tag(:span, link_title, :class => :name)) unless address_link
    content_tag(:p, content_tag(:span, link_title, :class => :name) + ", " + content_tag(:span, address_link, :class => :address))
  end

  def link_title(gsub = nil)
    organization? ? link_to_organization(gsub) : title.text_gilensize
  end

  def link_short_title
    link_title('with_gsub')
  end

  def address_link
    return link_to(organization.address, '#', :title => 'Показать на карте',
                    :'data-latitude' => organization.latitude,
                    :'data-longitude' => organization.longitude,
                    :'data-hint' => title.text_gilensize,
                    :'data-id' => organization.try(:id),
                    :class => 'show_map_link') if latitude? && longitude?
  end

  def link_to_organization(gsub = nil)
    place_title = organization.title
    place_title = place_title.gsub(/,.*/, '') if gsub
    link_title = link_to place_title.text_gilensize, OrganizationDecorator.decorate(organization).organization_url, :title => organization.title
  end

end
