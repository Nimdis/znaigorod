# encoding: utf-8

class AfishaObserver < ActiveRecord::Observer
  def after_approve(afisha, transition)
    afisha.messages.create(account: afisha.user.present? ? afisha.user.account : nil,
                           kind: :afisha_published)
  end

  def after_send_to_author(afisha, transition)
    afisha.messages.create(account: afisha.user.present? ? afisha.user.account : nil,
                           kind: :afisha_returned)
  end
end
