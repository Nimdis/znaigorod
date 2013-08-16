# encoding: utf-8

class VisitObserver < ActiveRecord::Observer
  def after_create(visit)
    if visit.visitable.is_a?(Afisha) && visit.visitable.user.present?
      Message.delay.create(
        account: visit.visitable.user.account,
        producer: visit.user.account,
        kind: :user_visit_afisha,
        messageable: visit.visitable)
    end
  end

  def after_save(visit)
    visit.visitable.delay.update_rating
    visit.user.account.delay.update_rating
  end
end
