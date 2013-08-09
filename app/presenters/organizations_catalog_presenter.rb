# encoding: utf-8

class OrganizationsCatalogPresenter
  include ActiveAttr::MassAssignment
  attr_accessor :categories,
                :lat, :lon, :radius,
                :page, :per_page

  include Rails.application.routes.url_helpers

  include OrganizationsPresenter

  acts_as_organizations_presenter kind: :organization, filters: [:categories]


  def self.suborganization_models
    [Organization, Meal, Entertainment, Sauna, CarWash, CarSalesCenter, Culture, Sport, Creation, SalonCenter]
  end

  def categories_filter
    Hashie::Mash.new :selected => [], :available => []
  end

  def categories_links
    []
  end

  def meta_description
    desc = ""

    self.class.suborganization_models.map(&:name).map(&:downcase).each do |kind|
      desc << self.send("#{kind}_categories").map(&:value).join(', ').mb_chars.capitalize
      desc << ', '
      desc << I18n.t("organization.list_title.#{kind}").mb_chars.downcase
      desc << " в Томске. "
    end

    "<meta name='description' content='#{desc.squish}' />".html_safe
  end
end
