# encoding: utf-8

class AfishaObserver < ActiveRecord::Observer
  def after_approve(afisha, transition)
    MyMailer.delay.mail_new_published_afisha(afisha)
    if afisha.user.present?
      NotificationMessages.delay.create(
        account: afisha.user.account,
        kind: :afisha_published,
        messageable: afisha)
      afisha.delay.update_account_rating
    end
  end

  def after_pending(afisha, transition)
    MyMailer.delay.mail_new_pending_afisha(afisha)
  end

  def after_send_to_author(afisha, transition)
    if afisha.user.present?
      NotificationMessages.delay.create(
        account: afisha.user.account,
        kind: :afisha_returned,
        messageable: afisha)
    end
  end

  def after_save(afisha)
    afisha.delay.reindex_showings
    afisha.delay.save_version if afisha.published?
  end
end
