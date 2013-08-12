class FriendsController < ApplicationController
  inherit_resources

  actions :index
  custom_actions collection: :change_friendship

  belongs_to :account, :polymorphic => true

  def index
    index!{
      @presenter = AccountPresenter.new(params)
      render partial: 'accounts/account_posters', layout: false and return if request.xhr?
    }
  end

  def change_friendship
    change_friendship!{
      if current_user
        @friend = current_user.account.friendly_for(parent).first || current_user.account.friends.create(friendable: parent)
        @friend.change_friendship
      end

      render :partial => 'friend', :locals => { friend: @friend } and return
    }
  end

  private

  def collection
    @friends = current_user.account.friends.approved.map(&:friendable)
    Kaminari.paginate_array(@friends).page(params[:page]).per(per_page)
  end

  def per_page
    18
  end
end
