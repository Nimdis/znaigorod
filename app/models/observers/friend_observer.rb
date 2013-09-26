# encoding: utf-8

class FriendObserver < ActiveRecord::Observer
  def after_create(friend)
    NotificationMessage.delay(:queue => 'critical').create(
      account: friend.friendable,
      producer: friend.account,
      kind: :user_add_friend,
      messageable: friend)
  end
end
