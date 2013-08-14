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
    account.avatar_url? ? resized_image_url(account.avatar_url, 88, 88, false) : 'public/stub_poster.png'
  end

  def buddies
    friends.approved.map(&:friendable).first(5)
  end
end
