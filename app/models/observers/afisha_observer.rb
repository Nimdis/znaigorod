# encoding: utf-8

class AfishaObserver < ActiveRecord::Observer
  def after_approve(afisha, transition)
    MyMailer.delay(:queue => 'mailer').mail_new_published_afisha(afisha) unless afisha.user.is_admin? || afisha.user.email.blank?
    if afisha.user.present? && !afisha.user.is_admin?
      NotificationMessage.delay(:queue => 'critical').create(
        account: afisha.user.account,
        kind: :afisha_published,
        messageable: afisha)
      #afisha.user.account.delay.update_rating if afisha.user.present?
    end
  end

  def after_pending(afisha, transition)
    MyMailer.delay(:queue => 'mailer').mail_new_pending_afisha(afisha) unless afisha.user.is_admin?
  end

  def after_send_to_author(afisha, transition)
    if afisha.user.present?
      NotificationMessage.delay(:queue => 'mailer').create(
        account: afisha.user.account,
        kind: :afisha_returned,
        messageable: afisha) unless afisha.user.is_admin?
    end
  end

  def before_save(afisha)
    if afisha.published? && afisha.change_versionable?
      afisha.save_version
      MyMailer.delay(:queue => 'mailer').send_afisha_diff(afisha.versions.last) if afisha.versions.last.present?
    end
  end

  def after_save(afisha)
    return unless afisha.published?

    afisha.delay.reindex_showings
    afisha.delay.upload_poster_to_vk if (afisha.check_poster_changed? || afisha.versions.empty? || afisha.poster_vk_id.nil?) && afisha.poster_url?
  end
end
