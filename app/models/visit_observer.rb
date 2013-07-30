# encoding: utf-8

class VisitObserver < ActiveRecord::Observer
  def after_create(visit)
    if visit.visitable.is_a?(Afisha)
      visit.messages.create(account: visit.visitable.user.present? ? visit.visitable.user.account : nil,
                            user: visit.user,
                            kind: :user_visit_afisha)
    end
  end
end
