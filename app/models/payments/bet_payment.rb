# encoding: utf-8

require 'payments/payment'

class BetPayment < Payment
  attr_accessible :phone

  has_one :sms, :as => :smsable

  validates :phone, :presence => true, :format => { :with => /\+7-\(\d{3}\)-\d{3}-\d{4}/ }

  after_validation :set_amount

  delegate :message, :to => :paymentable
  def approve!
    super
    paymentable.pay!
    create_sms! :phone => phone, :message => message
  end

  private

  def set_amount
    self.amount = paymentable.amount
  end
end

# == Schema Information
#
# Table name: payments
#
#  id               :integer          not null, primary key
#  paymentable_id   :integer
#  number           :integer
#  phone            :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  paymentable_type :string(255)
#  type             :string(255)
#  amount           :float
#  details          :text
#  state            :string(255)
#

