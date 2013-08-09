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
    @categories_links ||= [].tap { |array|
      array << {
        title: 'Все',
        klass: 'all',
        url: "#{pluralized_kind}_path",
        parameters: {},
        selected: categories_filter[:selected].empty?,
        count: HasSearcher.searcher(pluralized_kind.to_sym).total
      }
      {'meal' => 'бары'}.each do |kind, category|
        array << {
          title: category.capitalize,
          klass: Russian.translit(category).gsub(" ", "_"),
          url: "#{kind.pluralize}_path",
          parameters: {
            categories: [category]
          },
          selected: categories_filter[:selected].include?(category),
          count: HasSearcher.searcher(kind.pluralize.to_sym, meal_category: [category]).total
        }
      end
    }
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
