# encoding: utf-8

class Copy < ActiveRecord::Base
  extend Enumerize

  attr_accessible :code, :state

  belongs_to :copyable, :polymorphic => true
  belongs_to :copy_payment

  has_many :smses, :as => :smsable

  before_create :set_code_and_state

  scope :by_state, ->(state) { where :state => state }
  scope :for_coupons, -> { where :copyable_type => 'Coupon' } 
  scope :for_sale, -> { by_state 'for_sale' }
  scope :for_tickets, -> { where :copyable_type => 'Ticket' } 
  scope :reserved, -> { by_state 'reserved' }
  scope :sold,     -> { by_state 'sold' }

  enumerize :state, :in => [:for_sale, :reserved, :sold]

  searchable do
    integer :id
    string :copyable_type
    string :state
    string(:copyable_id_str) { copyable_id.to_s }
  end

  def reserve!
    update_attributes :state => 'reserved'
  end

  def sell!
    update_attributes :state => 'sold'
  end

  def release!
    inform_purchaser

    self.state = 'for_sale'
    self.copy_payment_id = nil
    self.save
  end

  private

  def set_code_and_state
    self.code = 4.times.map { Random.rand(10) }.join
    self.state = 'for_sale'
  end

  def inform_purchaser
    smses.create! :phone => copy_payment.phone, :message => 'Время ожидания платежа за билет истекло.'
  end
end

# == Schema Information
#
# Table name: copies
#
#  id            :integer          not null, primary key
#  state         :string(255)
#  code          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  payment_id    :integer
#  copyable_id   :integer
#  copyable_type :string(255)
#

