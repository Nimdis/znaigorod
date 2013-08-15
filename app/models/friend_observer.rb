# encoding: utf-8

class FriendObserver < ActiveRecord::Observer
  def after_create(friend)
    friend.messages.create(account: friend.friendable, producer: friend.account, kind: :user_add_friend)
  end
end
