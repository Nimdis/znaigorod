# encoding: utf-8

class OrganizationCollectionKeywords
  attr_accessor :organization_collection_presenter

  delegate :organization_class, :category_search_params, :to => :organization_collection_presenter

  def initialize(organization_collection_presenter)
    @organization_collection_presenter = organization_collection_presenter
  end

  def to_s
    keywords.map(&:mb_chars).map(&:downcase).join(',')
  end

  private

  def keywords
    keywords = []

    keywords << 'томск'
    keywords += categories
    keywords += features
  end

  def categories
    organization_collection_presenter.send("#{organization_class}_categories").map(&:value)
  end

  def features
    organization_collection_presenter.send("#{organization_class}_searcher", category_search_params).facet("#{organization_class}_feature").rows.map(&:value)
  end
end
