# encoding: utf-8

class AfishaObserver < ActiveRecord::Observer
  def after_approve(afisha, transition)
    MyMailer.delay.mail_new_published_afisha(afisha) unless afisha.user.is_admin?
    if afisha.user.present? && !afisha.user.is_admin?
      NotificationMessage.delay.create(
        account: afisha.user.account,
        kind: :afisha_published,
        messageable: afisha)
      #afisha.user.account.delay.update_rating if afisha.user.present?
    end
  end

  def after_pending(afisha, transition)
    MyMailer.delay.mail_new_pending_afisha(afisha) unless afisha.user.is_admin?
  end

  def after_send_to_author(afisha, transition)
    if afisha.user.present?
      NotificationMessage.delay.create(
        account: afisha.user.account,
        kind: :afisha_returned,
        messageable: afisha) unless afisha.user.is_admin?
    end
  end

  def before_save(afisha)
    if afisha.published? && afisha.change_versionable?
      afisha.delay.save_version
      MyMailer.delay.send_afisha_diff(afisha) if afisha.user.present? && !afisha.user.is_admin?
    end
  end

  def after_save(afisha)
    afisha.delay.reindex_showings
  end
end
