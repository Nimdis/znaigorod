# encoding: utf-8

class OrganizationsCollection
  include ActiveAttr::MassAssignment
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  attr_accessor :organization_class, :category, :query, :page

  def initialize(params)
    super(params)

    @category ||= 'all'
    @category = @category.mb_chars.downcase
    @organization_class ||= 'organizations'
    @organization_class = @organization_class.singularize
    @query ||= ''
  end

  def self.kinds
    [Meal, Entertainment, Culture, Sport, Creation]
  end

  self.kinds.map(&:name).map(&:downcase).each do |klass|
    define_method "#{klass}_searcher" do |params = {}|
      HasSearcher.searcher(klass.to_sym, params)
    end

    define_method "#{klass}_categories_links" do
      self.send("#{klass}_categories").map do |row|
        Link.new(title: "#{row.value.mb_chars.capitalize} (#{row.count})", url: organizations_path(organization_class: klass.pluralize, category: row.value.mb_chars.downcase))
      end
    end

    define_method "#{klass}_categories" do
      self.send("#{klass}_searcher").facet("#{klass}_category").rows
    end
  end

  def category_all?
    category == 'all'
  end

  def kind_links
    {}.tap do |links|
      self.class.kinds.map(&:name).map(&:downcase).each do |klass|
        links[Link.new(title: I18n.t("organization.kind.#{klass}"), url: organizations_path(organization_class: klass.pluralize))] = self.send("#{klass}_categories_links")
      end
    end
  end

  def class_categories_links
    [Link.new(title: I18n.t("organization.all.#{organization_class}"), url: organizations_path(organization_class: organization_class.pluralize), current: category == 'all')].tap do |links|
      self.send("#{organization_class}_categories").each do |row|
        link_kind = row.value.mb_chars.downcase
        links << Link.new(title: "#{row.value.mb_chars.capitalize} (#{row.count})", url: organizations_path(organization_class: organization_class.pluralize, category: link_kind), current: category == link_kind)
      end
      current_index = links.index { |link| link.current? }
      raise ActionController::RoutingError.new('Not Found') unless current_index
      links[current_index - 1].html_options[:class] = :before_current if current_index > 0
      links[current_index + 1].html_options[:class] = :after_current if current_index < links.size - 1
      links[current_index].html_options[:class] = :current
    end
  end

  def categories
    query_to_hash['categories'] || []
  end

  def features
    query_to_hash['features'] || []
  end

  def offers
    query_to_hash['offers'] || []
  end

  def cuisines
    query_to_hash['cuisines'] || []
  end

  def stuffs
    query_to_hash['stuffs'] || []
  end

  def keywords
    filter_groups.map(&:pluralize)
  end

  def query_to_hash
    {}.tap do |hash|
      keyword = ''

      query.split('/').each do |word|
        keyword = word and hash[keyword] ||= [] and next if keywords.include?(word)
        hash[keyword] << word
      end
    end
  end

  def title
    I18n.t("organization.list_title.#{organization_class}")
  end

  def subtitle
    return title if category == 'all'

    category
  end

  def filter_groups
    groups = []
    groups << 'stuff'
    groups << 'category' if category == 'all'
    groups << 'cuisine' if organization_class == 'meal'
    groups << 'offer' unless %w[sport creation].include?(organization_class)
    groups += ['feature']
  end

  def filters
    {}.tap do |hash|
      filter_groups.each do |group|
        hash[group] = self.send("#{group}_filters")
      end
    end
  end

  def category_search_params
    return {} if category == 'all'

    { "#{organization_class}_category" => [category] }
  end

  def list_search_params
    category_search_params.merge(Hash[query_to_hash.map do |key, value| ["#{organization_class}_#{key.singularize}", value] end ])
  end

  def filter_link_url(params)
    filter_params = {}
    filter_groups.each do |filter|
      existed_filter_params = self.send(filter.pluralize) || []
      tag = params[filter.to_sym]
      if existed_filter_params.include?(tag)
        existed_filter_params = existed_filter_params - [tag]
      else
        existed_filter_params << tag
      end
      filter_params[filter] = existed_filter_params
    end
    query = []
    filter_params.each do |key, values|
      next if values == [nil]
      query += [key.pluralize] + values
    end
    organizations_path(organization_class: organization_class.pluralize, category: category, query: query.compact.join("/"))
  end

  def category_filters
    existed_categories = self.send("#{organization_class}_searcher", list_search_params).facet("#{organization_class}_category").rows.map(&:value)
    self.send("#{organization_class}_searcher", category_search_params).facet("#{organization_class}_category").rows.map(&:value).
      map { |value|
        Link.new(title: value,
                 url: filter_link_url(category: value),
                 html_options: { :class => (categories.include?(value) ? 'selected' : nil) },
                 disabled: !existed_categories.include?(value)
                )
    }
  end

  def cuisine_filters
    existed_cuisines = self.send("#{organization_class}_searcher", list_search_params).facet("#{organization_class}_cuisine").rows.map(&:value)
    self.send("#{organization_class}_searcher", category_search_params).facet("#{organization_class}_cuisine").rows.map(&:value).map { |value|
      Link.new title: value,
        url: filter_link_url(cuisine: value),
        html_options: { :class => (cuisines.include?(value) ? 'selected' : nil)},
        disabled:  !existed_cuisines.include?(value)
    }
  end

  def offer_filters
    existed_offers = self.send("#{organization_class}_searcher", list_search_params).facet("#{organization_class}_offer").rows.map(&:value)
    self.send("#{organization_class}_searcher", category_search_params).facet("#{organization_class}_offer").rows.map(&:value).
      map { |value| Link.new title: value,
            url: filter_link_url(offer: value),
            html_options: { :class => (offers.include?(value) ? 'selected' : nil) } ,
            disabled: !existed_offers.include?(value) }
  end

  def feature_filters
    existed_features = self.send("#{organization_class}_searcher", list_search_params).facet("#{organization_class}_feature").rows.map(&:value)
    self.send("#{organization_class}_searcher", category_search_params).facet("#{organization_class}_feature").rows.map(&:value).
      map { |value| Link.new title: value,
            url: filter_link_url(feature: value),
            html_options: { :class => (features.include?(value) ? 'selected' : nil) },
            disabled: !existed_features.include?(value)}
  end

  def stuff_filters
    existed_stuffs = self.send("#{organization_class}_searcher", list_search_params).facet("#{organization_class}_stuff").rows.map(&:value)
    self.send("#{organization_class}_searcher", category_search_params).facet("#{organization_class}_stuff").rows.map(&:value).map { |value|
      Link.new title: value,
        url: filter_link_url(stuff: value),
        html_options: { :class => (stuffs.include?(value) ? 'selected' : nil)},
        disabled:  !existed_stuffs.include?(value)
    }
  end

  def decorator_class
    "#{organization_class}_decorator".classify.constantize
  end

  def suborganizations
    decorator_class.decorate paginated_suborganizations
  end

  def paginated_suborganizations
     self.send("#{organization_class}_searcher", list_search_params).paginate(:page => page, :per_page => 10).results
  end

  def view
    organization_class == 'organization' ? 'catalog' : 'index'
  end

  def meta_description_organizations
    desc = ""
    desc << self.send("#{organization_class}_categories").map(&:value).join(", ").mb_chars.capitalize
    desc << ", "
    desc << I18n.t("organization.list_title.#{organization_class}").mb_chars.downcase
    desc << " в Томске. "
    "<meta name='description' content='#{desc.squish}' />".html_safe
  end

  def meta_description_organizations_catalog
    desc = ""
    self.class.kinds.map(&:name).map(&:downcase).each do |klass|
      desc << self.send("#{klass}_categories").map(&:value).join(", ").mb_chars.capitalize
      desc << ", "
      desc << I18n.t("organization.list_title.#{klass}").mb_chars.downcase
      desc << " в Томске. "
    end
    "<meta name='description' content='#{desc.squish}' />".html_safe
  end

  def meta_keywords
    tag(:meta, name: 'keywords', content: OrganizationCollectionKeywords.new(self).to_s)
  end
end
