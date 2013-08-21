class FriendsController < ApplicationController
  inherit_resources

  actions :index
  custom_actions collection: [:change_friendship, :buddies]

  belongs_to :account, :polymorphic => true
  has_scope :page, :default => 1

  def index
    index!{
      @presenter = AccountPresenter.new(params)
      render partial: 'accounts/account_posters', locals: { collection: @accounts }, layout: false and return if request.xhr?
    }
  end

  def buddies
    buddies!{
      render partial: 'friends/account_friends', locals: { collection: @accounts.page(params[:page]).per(5) }, layout: false and return
    }
  end

  def change_friendship
    change_friendship!{
      if current_user
        @friend = current_user.account.friendly_for(parent).first || current_user.account.friends.create(friendable: parent)
        @friend.change_friendship
      end

      render :partial => 'friendship', :locals => { friend: @friend } and return
    }
  end

  private

  def collection
    @accounts = Kaminari.paginate_array(current_user.account.friends.approved.map(&:friendable)).page(params[:page]).per(18)
  end
end
