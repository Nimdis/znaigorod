# encoding: utf-8

class Payment < ActiveRecord::Base
  attr_accessible :number, :phone

  belongs_to :ticket_info
  belongs_to :user

  has_one :sms, :as => :smsable

  has_many :tickets, after_add: :reserve_ticket

  validates :number, :presence => true, :numericality => { :greater_than => 0 }
  validates :phone, :presence => true, :format => { :with => /\+7-\(\d{3}\)-\d{3}-\d{4}/ }

  before_validation :check_tickets_number
  after_create :reserve_tickets

  def amount
    ticket_info.price * number
  end

  def approve
    tickets.map(&:sell!)

    create_sms! :phone => phone, :message => message
  end

  def cancel
    tickets.map(&:release!)
  end

  private

  def check_tickets_number
    errors[:base] << I18n.t('activerecord.errors.messages.not_enough_tickets') if ticket_info.tickets_for_sale.count < number
  end

  def reserve_tickets
    tickets << ticket_info.tickets.for_sale.limit(number)
  end

  def reserve_ticket(ticket)
    ticket.reserve!
  end

  def message
    "#{ticket_info.affiche.title}. " << (tickets.many? ? 'Коды билетов: ' : 'Код билета: ') << tickets.pluck(:code).join(', ')
  end
end

# == Schema Information
#
# Table name: payments
#
#  id             :integer          not null, primary key
#  ticket_info_id :integer
#  number         :integer
#  phone          :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

