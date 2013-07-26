class AccountsController < ApplicationController
  inherit_resources
  actions :index, :show
  custom_actions :resource => [:follow, :unfollow]
  has_scope :page, :default => 1

  def index
    index! {
      render partial: 'accounts/accounts_list', layout: false and return if request.xhr?
    }
  end

  def follow
    current_user.account.follow!(Account.find(params[:account_id]))
    render :nothing => true
  end

  def unfollow
    current_user.account.unfollow!(Account.find(params[:account_id]))
    render :nothing => true
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
