# encoding: utf-8

class AfishaObserver < ActiveRecord::Observer
  def after_approve(afisha, transition)
    if afisha.user.present?
      afisha.messages.create(account: afisha.user.account, kind: :afisha_published)
    end
  end

  def after_send_to_author(afisha, transition)
    if afisha.user.present?
      afisha.messages.create(account: afisha.user.account, kind: :afisha_returned)
    end
  end
end
