class Ticket < ActiveRecord::Base
  extend Enumerize

  attr_accessible :code, :state

  belongs_to :ticket_info
  belongs_to :payment

  before_create :set_code_and_state

  scope :by_state, ->(state) { where :state => state }
  scope :for_sale, -> { by_state 'for_sale' }
  scope :reserved, -> { by_state 'reserved' }
  scope :sold,     -> { by_state 'sold' }

  enumerize :state, :in => [:for_sale, :reserved, :sold]

  def reserve!
    update_attributes :state => 'reserved'
  end

  def sell!
    update_attributes :state => 'sold'
  end

  def release!
    self.state = 'for_sale'
    self.payment_id = nil
    self.save
  end

  private

  def set_code_and_state
    self.code = 4.times.map { Random.rand(10) }.join
    self.state = 'for_sale'
  end
end

# == Schema Information
#
# Table name: tickets
#
#  id             :integer          not null, primary key
#  ticket_info_id :integer
#  state          :string(255)
#  code           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  payment_id     :integer
#

