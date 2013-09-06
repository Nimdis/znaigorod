# encoding: utf-8

require 'payments/payment'

class BetPayment < Payment
  attr_accessible :phone

  has_one :sms, :as => :smsable

  validates :phone, :presence => true, :format => { :with => /\+7-\(\d{3}\)-\d{3}-\d{4}/ }

  after_validation :set_amount

  def approve!
    super
    paymentable.pay!
    create_sms! :phone => phone, :message => message
  end

  private

  def message
    'MESSAGE'
  end

  def set_amount
    self.amount = paymentable.amount
  end
end
