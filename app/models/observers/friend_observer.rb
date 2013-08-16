# encoding: utf-8

class FriendObserver < ActiveRecord::Observer
  def after_create(friend)
    Message.delay.create(
      account: friend.friendable,
      producer: friend.account,
      kind: :user_add_friend,
      messageable: friend)
    friend.friendable.delay.update_rating
    friend.account.delay.update_rating
  end
end
