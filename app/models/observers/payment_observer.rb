# encoding: utf-8

class PaymentObserver < ActiveRecord::Observer
  def after_save(payment)
    payment.user.account.delay.update_rating if payment.user
  end
end
