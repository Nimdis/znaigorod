class FriendsController < ApplicationController
  inherit_resources
  load_and_authorize_resource

  actions :index
  custom_actions resource: :change_friendship

  belongs_to :account, :polymorphic => true
  has_scope :page, :default => 1

  def index
    index! {
      render partial: 'friends/account_friends', locals: { collection: @accounts }, layout: false and return
    }
  end

  def change_friendship
    raise CanCan::AccessDenied unless current_user
    @friend = current_user.account.friendly_for(parent).first || current_user.account.friends.create(friendable: parent)
    @friend.change_friendship
    render :partial => 'friendship' and return
  end

  private

  def collection
    @accounts = Kaminari.paginate_array(@account.friends.approved.map(&:friendable)).page(params[:page]).per(5)
  end
end
