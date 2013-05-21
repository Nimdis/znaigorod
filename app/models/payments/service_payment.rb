# encoding: utf-8

require 'payments/payment'

class ServicePayment < Payment
  attr_accessible :amount, :details

  validates_presence_of :amount, :details
end
