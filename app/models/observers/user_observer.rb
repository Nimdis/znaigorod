# encoding: utf-8

class UserObserver < ActiveRecord::Observer
  def after_save(user)
    #user.delay.get_friends_from_socials
  end
end
