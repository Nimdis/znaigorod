class Offer < ActiveRecord::Base
  attr_accessible :number, :price, :description

  belongs_to :coupon
end
