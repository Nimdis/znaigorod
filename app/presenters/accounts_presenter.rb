# encoding: utf-8

class AccountsPresenter
  class KindFilter
    attr_accessor :kind

    def initialize(kind)
      @kind = available_values.keys.include?(kind) ? kind : available_values.keys.first
    end

    def self.available_values
      { 'all' => 'Все', 'admin' => 'Администраторы', 'afisha_editor' => 'Авторы афиш' }
    end

    def available_values
      self.class.available_values
    end

    available_values.each do |value, _|
      define_method "#{value}_selected?" do
        kind == value
      end
    end
  end

  class GenderFilter
    attr_accessor :gender

    def initialize(gender)
      @gender = available_values.keys.include?(gender) ? gender : available_values.keys.first
    end

    def self.available_values
      { 'undefined' => 'Все', 'female' => 'Девушки', 'male' => 'Парни' }
    end

    def available_values
      self.class.available_values
    end

    available_values.each do |value, _|
      define_method "#{value}_selected?" do
        gender == value
      end
    end
  end

  class ActsAsFilter
    attr_accessor :acts_as

    def initialize(acts_as)
      @acts_as = acts_as
    end

    def self.available_values
      { 'inviter' => 'Приглашают', 'invited' => 'Ждут приглашения' }
    end

    def available_values
      self.class.available_values
    end

    available_values.each do |value, _|
      define_method "#{value}_selected?" do
        acts_as == value
      end
    end

    def used?
      acts_as.present?
    end
  end

  class CategoriesFilter
    attr_accessor :selected, :available

    def initialize(categories)
      @available = Values.instance.invitation.categories
      @selected  = (categories || []).delete_if(&:blank?) & @available
    end

    def used?
      selected.any?
    end
  end

  include ActiveAttr::MassAssignment

  attr_accessor :gender, :kind, :acts_as,
                :inviter_categories, :invited_categories,
                :order_by, :page, :per_page

  attr_reader :kind_filter, :gender_filter, :acts_as_filter,
    :inviter_categories_filter, :invited_categories_filter

  def initialize(args)
    super(args)

    normalize_args
    initialize_filters
  end

  def link_params(acts_as = nil)
    { :kind => kind_filter.kind, :gender => gender_filter.gender }.tap do |hash|
      if acts_as_filter.used?
        hash[:acts_as] = acts_as if acts_as_filter.acts_as != acts_as
      else
        hash[:acts_as] = acts_as
      end
    end
  end

  def collection
    searcher.results
  end

  def count(params)
    params.delete(:kind) if params[:kind] == 'all'
    params.delete(:gender) if params[:gender] == 'undefined'

    HasSearcher.searcher(:accounts, params).total
  end

  private

  def normalize_args
    @inviter_categories ||= []
    @invited_categoires ||= []
    @page               ||= 1
    @per_page           = 18
  end

  def initialize_filters
    @kind_filter               ||= KindFilter.new(kind)
    @gender_filter             ||= GenderFilter.new(gender)
    @acts_as_filter            ||= ActsAsFilter.new(acts_as)
    @inviter_categories_filter ||= CategoriesFilter.new(inviter_categories)
    @invited_categories_filter ||= CategoriesFilter.new(invited_categories)
  end

  def searcher_params
    @searcher_params ||= {}.tap do |params|
      params[:kind]               = kind_filter.kind unless kind_filter.all_selected?
      params[:gender]             = gender_filter.gender unless gender_filter.undefined_selected?
      params[:acts_as]            = acts_as_filter.acts_as if acts_as_filter.used?
      params[:inviter_categories] = inviter_categories_filter.selected
    end
  end

  def searcher
    @searcher ||= HasSearcher.searcher(:accounts, searcher_params).tap { |s|
      s.paginate(page: page, per_page: per_page)
    }
  end
end
