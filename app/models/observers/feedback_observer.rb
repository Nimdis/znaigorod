# encoding: utf-8

class FeedbackObserver < ActiveRecord::Observer
  def after_save(feedback)
    FeedbackMailer.delay(:queue => 'mailer').send_email(feedback)
  end
end
