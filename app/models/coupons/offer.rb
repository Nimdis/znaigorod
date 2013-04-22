class Offer < ActiveRecord::Base
  attr_accessible :number, :price, :description

  belongs_to :coupon
end

# == Schema Information
#
# Table name: offers
#
#  id          :integer          not null, primary key
#  coupon_id   :integer
#  price       :integer
#  number      :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

