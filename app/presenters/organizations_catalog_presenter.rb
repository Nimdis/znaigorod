# encoding: utf-8

class OrganizationsCatalogPresenter
  include Rails.application.routes.url_helpers

  def self.suborganization_models
    [Meal, Entertainment, Culture, Sport, Creation]
  end

  self.suborganization_models.map(&:name).map(&:downcase).each do |kind|
    define_method "#{kind}_searcher" do |params = {}|
      HasSearcher.searcher(kind.pluralize.to_sym)
    end

    define_method "#{kind}_categories_links" do
      self.send("#{kind}_categories").map do |row|
        Link.new(title: "#{row.value.mb_chars.capitalize} (#{row.count})", url: send("#{kind.pluralize}_path", categories: [row.value.mb_chars.downcase]))
      end
    end

    define_method "#{kind}_categories" do
      self.send("#{kind}_searcher").facet("#{kind}_category").rows
    end
  end

  def catalog
    {}.tap do |hash|
      self.class.suborganization_models.map(&:name).map(&:downcase).each do |kind|
        hash[Link.new(title: I18n.t("organization.kind.#{kind}"), url: send("#{kind.pluralize}_path"))] = send("#{kind}_categories_links")
      end
    end
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
