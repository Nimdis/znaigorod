class Ticket < ActiveRecord::Base
  attr_accessible :code, :phone, :state

  belongs_to :ticket_info
  belongs_to :payment

  before_create :set_code_and_state

  scope :for_sale, -> { where state: 'for_sale' }
  scope :reserved, -> { where state: 'reserved' }
  scope :sold,     -> { where state: 'sold' }

  def reserve!
    update_attributes state: 'reserved'
  end

  def sell!
    update_attributes state: 'sold'
  end

  private

  def set_code_and_state
    self.code = SecureRandom.hex(3)
    self.state = 'for_sale'
  end
end
