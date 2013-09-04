class Bet < ActiveRecord::Base
  attr_accessible :amount, :number

  belongs_to :afisha
  belongs_to :user

  validates_presence_of :amount, :number

  default_value_for :number, 1

  delegate :price_min, :to => :afisha, :prefix => true
  def price_min
    (afisha_price_min - afisha_price_min * 0.3).round
  end
end
