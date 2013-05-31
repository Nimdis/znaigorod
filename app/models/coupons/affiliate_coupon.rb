require 'coupons/coupon'

class AffiliateCoupon < Coupon
  attr_accessible :affiliate_url

  validates_presence_of :affiliate_url

  scope :affiliated, -> { where('affiliate_url IS NOT NULL') }

  private

  def create_copies
    super unless affiliate_url?
  end
end
