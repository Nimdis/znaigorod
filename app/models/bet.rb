#encoding: utf-8

class Bet < ActiveRecord::Base
  attr_accessible :amount, :number

  belongs_to :afisha
  belongs_to :user

  has_many :notification_messages, :as => :messageable, :dependent => :destroy

  has_one :account, :through => :user
  has_one :bet_payment, :as => :paymentable, :dependent => :destroy

  validates :number, :presence => true, :numericality => { :greater_than => 0 }
  validates :amount, :numericality => { :message => 'неверное значение' }

  before_create :set_codes

  after_create :send_notification_to_afisha_author

  serialize :codes, Array

  default_value_for :number, 1
  default_value_for(:amount) { |bet| bet.price_min }

  state_machine :state, :initial => :fresh do
    event(:approve) { transition :fresh => :approved }
    event(:cancel)  { transition :fresh => :canceled }
    event(:pay)     { transition :approved => :paid }

    after_transition :fresh    => :canceled, :do => :handle_cancel
    after_transition :fresh    => :approved, :do => :handle_approval
    after_transition :approved => :paid,     :do => :handle_pay
  end

  def price_min
    afisha_price_min = afisha.price_min

    (afisha_price_min - afisha_price_min * 0.3).round
  end

  def message
    "#{afisha.description}. " << (number > 1 ? 'Коды: ' : 'Код: ') << codes.join(', ')
  end

  private

  def set_codes
    self.codes = number.times.map do
      4.times.map { Random.rand(10) }.join
    end
  end

  def send_notification_to_afisha_author
    notification_messages.create! :producer => account,
      :account => afisha.user.account, :kind => :auction_bet
  end

  def handle_cancel
    notification_messages.create! :producer => afisha.user.account,
      :account => account, :kind => :auction_bet_cancel
  end

  def handle_approval
    notification_messages.create! :producer => afisha.user.account,
      :account => account, :kind => :auction_bet_approve
  end

  def handle_pay
    notification_messages.create! :producer => account,
      :account => afisha.user.account, :kind => :auction_bet_pay
  end
end

# == Schema Information
#
# Table name: bets
#
#  id         :integer          not null, primary key
#  afisha_id  :integer
#  number     :integer
#  amount     :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state      :string(255)
#  codes      :string(255)
#

