class Ticket < ActiveRecord::Base
  extend Enumerize

  attr_accessible :code, :state

  belongs_to :ticket_info
  belongs_to :payment

  has_one :sms, :as => :smsable

  before_create :set_code_and_state

  scope :for_sale, -> { where state: 'for_sale' }
  scope :reserved, -> { where state: 'reserved' }
  scope :sold,     -> { where state: 'sold' }

  enumerize :state, :in => [:for_sale, :reserved, :sold]

  def reserve!
    update_attributes :state => 'reserved'
  end

  def sell!
    create_sms! :phone => payment.phone
    update_attributes :state => 'sold'
  end

  def release!
    update_attributes :state => 'for_sale'
  end

  private

  def set_code_and_state
    self.code = SecureRandom.hex(3)
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
#  phone          :string(255)
#  code           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  payment_id     :integer
#

