class FriendsController < ApplicationController
  inherit_resources

  custom_actions collection: :change_friendship

  belongs_to :account, :polymorphic => true

  def change_friendship
    change_friendship!{
      if current_user
        @friend = current_user.account.friendly_for(parent).first || current_user.account.friends.create(friendable: parent)
        @friend.change_friendship
      end

      render :nothing and return
    }
  end
end
