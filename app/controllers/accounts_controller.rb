class AccountsController < ApplicationController
  inherit_resources
  actions :index, :show
  custom_actions :resource => [:follow, :unfollow]
  has_scope :page, :default => 1

  def index
    index! {
      render partial: 'accounts/account_posters', layout: false and return if request.xhr?
    }
  end

  private

  def collection
    Account.search {
      order_by :rating, :desc
      paginate paginate_options.merge(:per_page => per_page)
    }.results
  end

  def per_page
    18
  end
end
