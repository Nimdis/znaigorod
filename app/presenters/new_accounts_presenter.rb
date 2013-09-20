# encoding: utf-8

class InviterCategoriesFilter
  attr_accessor :selected, :available

  def initialize(categories, hidden = false)
    @available = Values.instance.invitation.categories
    @selected  = (categories || []).delete_if(&:blank?) & @available
  end

  def used?
    selected.any?
  end
end

class NewAccountGenderFilter
  attr_accessor :selected, :available, :gender

  def initialize(gender)
    @gender = available_values.keys.map(&:to_s).include?(gender) ? gender : available_values.keys.first.to_s
  end

  def available_values
    { :undefined => 'Все', :male => 'Парни', :female => 'Девушки' }
  end

  def undefined_selected?
    gender == 'undefined'
  end

  def male_selected?
    gender == 'male'
  end

  def female_selected?
    gender == 'female'
  end
end

class NewAccountsPresenter
  include ActiveAttr::MassAssignment

  attr_accessor :gender, :kind,
                :inviter_categories, :invited_categoires,
                :invites, :waiting_invitation,
                :order_by, :page, :per_page

  def initialize(args)
    super(args)
    self.inviter_categories ||= []
    self.invited_categoires ||= []

    @page ||= 1
    @per_page   = 18

    initialize_filters
  end

  def initialize_filters
    @inviter_categories_filter ||= InviterCategoriesFilter.new(inviter_categories)
    @gender_filter ||= NewAccountGenderFilter.new(gender)
  end
  attr_reader :inviter_categories_filter, :gender_filter

  def collection
    searcher.results
  end

  def searcher_params
    @searcher_params ||= {}.tap do |params|
      params[:kind] = 'KIND' if false
      params[:gender] = gender_filter.gender
      params[:inviter_categories] = inviter_categories_filter.selected
    end
  end

  private

  def searcher
    @searcher ||= HasSearcher.searcher(:accounts, searcher_params).tap { |s|
      s.paginate(page: page, per_page: per_page)
    }
  end
end
