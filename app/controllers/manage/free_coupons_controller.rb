class Manage::FreeCouponsController < Manage::ApplicationController
  has_scope :page, default: 1

  def index
    @coupons = FreeCoupon.ordered.actual.page(params[:page]).per(12)
  end
end

