class Payment < ActiveRecord::Base
  attr_accessible :number, :phone

  belongs_to :ticket_info

  has_many :tickets, after_add: :reserve_ticket

  validates :number, presence: true, numericality: { greater_than: 0 }
  validates :phone, presence: true, format: { with: /\+7-\(\d{3}\)-\d{3}-\d{4}/ }

  before_create :check_tickets_number
  after_create :reserve_tickets

  def amount
    ticket_info.price * number
  end

  def approve!
    tickets.map(&:sell!)
  end

  private

  def check_tickets_number
    errors[:base] << 'not enough tickets' and return false if ticket_info.tickets_for_sale.count < number
  end

  def reserve_tickets
    tickets << ticket_info.tickets.for_sale.limit(number)
  end

  def reserve_ticket(ticket)
    ticket.reserve!
  end
end
