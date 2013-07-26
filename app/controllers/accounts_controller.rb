class AccountsController < ApplicationController
  inherit_resources
  actions :index, :show
  has_scope :page, :default => 1

  def index
    index! {
      render partial: 'accounts/accounts_list', layout: false and return if request.xhr?
    }
  end

  private

  def collection
    Account.search {
      keywords params[:search][:name] if params[:search]
      order_by :rating, :desc
      paginate paginate_options.merge(:per_page => per_page)
    }.results
  end
end
