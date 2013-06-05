# encoding: utf-8

class Copy < ActiveRecord::Base
  extend Enumerize

  attr_accessible :code, :state

  belongs_to :copyable, :polymorphic => true
  belongs_to :copy_payment

  has_many :smses, :as => :smsable

  before_create :set_code

  scope :for_coupons, -> { where :copyable_type => 'Coupon' }
  scope :for_tickets, -> { where :copyable_type => 'Ticket' }

  scope :by_state, ->(state) { where :state => state }

  scope :for_sale, -> { by_state 'for_sale' }
  scope :reserved, -> { by_state 'reserved' }
  scope :sold,     -> { by_state 'sold' }
  scope :stale,    -> { by_state 'stale' }

  default_scope order(:id)

  enumerize :state,
    :in => [:for_sale, :reserved, :sold, :stale],
    :default => :for_sale,
    :predicates => true

  searchable do
    integer :id

    string :copyable_type
    string :state
    string(:copyable_id_str) { copyable_id.to_s }

    text :description
  end

  def reserve!
    update_attributes :state => 'reserved'
  end

  def sell!
    update_attributes :state => 'sold'
  end

  def stale!
    update_attributes :state => 'stale' unless sold?
  end

  def release!
    inform_purchaser

    copy_payment.cancel!

    self.copy_payment_id = nil
    self.state = 'for_sale'
    self.save
  end

  def description
    case copyable
    when Ticket
      "#{copyable.affiche.title} #{copyable.affiche.organizations.map(&:title).join(' ')}"
    when Coupon
      "#{copyable.title} #{copyable.try(:organization).try(:title)}"
    end
  end

  private

  def set_code
    self.code = 4.times.map { Random.rand(10) }.join
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

