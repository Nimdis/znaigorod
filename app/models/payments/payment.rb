# encoding: utf-8

class Payment < ActiveRecord::Base
  attr_accessible :number, :phone

  belongs_to :ticket
  belongs_to :user

  has_one :sms, :as => :smsable

  has_many :copies, after_add: :reserve_copy

  validates :number, :presence => true, :numericality => { :greater_than => 0 }
  validates :phone, :presence => true, :format => { :with => /\+7-\(\d{3}\)-\d{3}-\d{4}/ }

  before_validation :check_tickets_number
  after_create :reserve_copies

  def amount
    ticket.price * number
  end

  def approve
    copies.map(&:sell!)

    create_sms! :phone => phone, :message => message
  end

  def cancel
    tickets.map(&:release!)
  end

  private

  def check_tickets_number
    errors[:base] << I18n.t('activerecord.errors.messages.not_enough_tickets') if number? && ticket.copies_for_sale.count < number
  end

  def reserve_copies
    copies << ticket.copies_for_sale.limit(number)
  end

  def reserve_copy(copy)
    copy.reserve!
  end

  def message
    "#{ticket.description}. " << (copies.many? ? 'Коды билетов: ' : 'Код билета: ') << copies.pluck(:code).join(', ')
  end
end

# == Schema Information
#
# Table name: payments
#
#  id         :integer          not null, primary key
#  ticket_id  :integer
#  number     :integer
#  phone      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

