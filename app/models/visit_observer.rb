# encoding: utf-8

class VisitObserver < ActiveRecord::Observer
  def after_create(visit)
    if visit.visitable.is_a?(Afisha)
      visit.messages.create(body: "На ваше мероприятие собирается пользователь: #{visit.user.account}",
                            account: visit.visitable.user.present? ? visit.visitable.user.account : nil)
    end
  end
end
