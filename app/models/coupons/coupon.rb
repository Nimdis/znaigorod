class Coupon < ActiveRecord::Base
  attr_accessible :description, :discount, :title

  has_many :offers, dependent: :destroy
end
