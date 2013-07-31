# encoding: utf-8

class FriendObserver < ActiveRecord::Observer
  def after_create(friend)
    comment.messages.create(account: friend.account,
                            user: friendable,
                            kind: :user_add_friend)
  end
end
