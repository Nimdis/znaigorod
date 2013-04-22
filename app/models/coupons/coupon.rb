class Coupon < ActiveRecord::Base
  attr_accessible :description, :discount, :title

  has_many :offers, dependent: :destroy
end

# == Schema Information
#
# Table name: coupons
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  discount    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

