class Ticket < ActiveRecord::Base
  attr_accessible :code, :phone, :state

  belongs_to :ticket_info

  before_create :set_code_and_state

  scope :for_sale, -> { where state: 'for_sale' }

  private

  def set_code_and_state
    self.code = SecureRandom.hex(3)
    self.state = 'for_sale'
  end
end
