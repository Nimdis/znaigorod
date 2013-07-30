# encoding: utf-8

class AfishaObserver < ActiveRecord::Observer
  def after_approve(afisha, translation)
    afisha.messages.create(body: "Ваша афиша #{afisha.title} опубликована",
                           account: afisha.user.present? ? afisha.user.account : nil)
  end

  def after_send_to_author(afisha, translation)
    afisha.messages.create(body: "Ваша афиша #{afisha.title} отклонена",
                           account: afisha.user.present? ? afisha.user.account : nil)
  end
end
