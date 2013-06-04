class FreeCoupon < Coupon
  validates_presence_of :discount, :place
end
