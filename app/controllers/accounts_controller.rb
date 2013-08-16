class AccountsController < ApplicationController
  inherit_resources
  actions :index, :show
  custom_actions :resource => [:follow, :unfollow]
  has_scope :page, :default => 1

  def index
    index! {
      @presenter = AccountPresenter.new(params)
      render partial: 'accounts/account_posters', layout: false and return if request.xhr?
    }
  end

  def show
    show! {
      @presenter = AccountPresenter.new(params)
      @account = AccountDecorator.new Account.find(params[:id])
      @comments = @account.comments.rendereable.page(1).per(3)
      @votes = @account.votes.rendereable.page(1).per(3)
    }
  end

  private

  def collection
    HasSearcher.searcher(:accounts, params).paginate(:page => params[:page], :per_page => per_page)
  end

  def per_page
    18
  end
end
