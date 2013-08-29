# encoding: utf-8

class VisitObserver < ActiveRecord::Observer
  def after_create(visit)
    if visit.visitable.is_a?(Afisha) && visit.visitable.user.present? && visit.user != visit.visitable.user
      NotificationMessage.delay.create(
        account: visit.visitable.user.account,
        producer: visit.user.account,
        kind: :user_visit_afisha,
        messageable: visit)
    end
  end

  def after_save(visit)
    visit.visitable.delay.update_rating if visit.visitable.present?
    visit.user.account.delay.update_rating if visit.user.present? && visit.user.account.present?
  end

  def after_destroy(visit)
    visit.visitable.delay.update_rating if visit.visitable.present?
    visit.user.account.delay.update_rating if visit.user.present? && visit.user.account.present?
  end
end
