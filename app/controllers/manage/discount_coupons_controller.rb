class Manage::DiscountCouponsController < Manage::ApplicationController
  has_scope :page, default: 1

  def index
    @coupons = DiscountCoupon.ordered.actual.page(params[:page]).per(12)
  end
end

