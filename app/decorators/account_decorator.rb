# encoding: utf-8

class AccountDecorator < ApplicationDecorator
  decorates :account

  def title
    "#{first_name} #{last_name}"
  end

  def show_url
    h.account_url(account)
  end

  def image
    resized_image_url(account.avatar.url, 88, 88, false)
  end

  def buddies
    friends.approved.map(&:friendable).first(5)
  end
end
