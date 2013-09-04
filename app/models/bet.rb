class Bet < ActiveRecord::Base
  attr_accessible :amount, :number

  belongs_to :afisha
  belongs_to :user

  validates_presence_of :amount, :number

  default_value_for :number, 1

  state_machine :state, :initial => :fresh do
    event(:to_approved) { transition :fresh => :approved }
    event(:to_canceled) { transition :fresh => :canceled }
  end

  scope :approved, -> { with_state :approved }
  scope :canceled, -> { with_state :canceled }

  delegate :price_min, :to => :afisha, :prefix => true
  def price_min
    (afisha_price_min - afisha_price_min * 0.3).round
  end
end
