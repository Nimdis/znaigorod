require 'coupons/coupon'

class PaidCoupon < Coupon
  include Copies

  attr_accessible  :price_with_discount, :price_without_discount, :price, :organization_quota, :number

  before_save :set_discount
  validates_presence_of :price, :number

  private

  def set_discount
    if self.price_without_discount? & self.price_with_discount?
      self.discount = ((self.price_without_discount - self.price_with_discount) * 100 / price_without_discount).round
    end
  end

end

# == Schema Information
#
# Table name: coupons
#
#  id                     :integer          not null, primary key
#  title                  :string(255)
#  description            :text
#  discount               :integer
#  vfs_path               :string(255)
#  organization_id        :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  image_file_name        :string(255)
#  image_content_type     :string(255)
#  image_file_size        :integer
#  image_updated_at       :datetime
#  image_url              :text
#  price_with_discount    :integer
#  price_without_discount :integer
#  organization_quota     :integer
#  price                  :integer
#  kind                   :string(255)
#  place                  :string(255)
#  count                  :integer
#  stale_at               :datetime
#  complete_at            :datetime
#

