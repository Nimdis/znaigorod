# encoding: utf-8

class VersionObserver < ActiveRecord::Observer
  def after_save(version)
    MyMailer.delay.send_afisha_diff(version)
  end
end
