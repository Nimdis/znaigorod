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
      @friends = Kaminari.paginate_array(@account.friends.approved.map(&:friendable)).page(1).per(5)
      @events = @account.afisha.page(1).per(3)
      @votes = @account.votes.rendereable.page(1).per(3)
      @visits = @account.visits.rendereable.page(1).per(3)
    }
  end
end
