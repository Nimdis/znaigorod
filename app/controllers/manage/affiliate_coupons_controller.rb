class Manage::AffiliateCouponsController < Manage::ApplicationController
  has_scope :page, default: 1

  def index
    @coupons = AffiliateCoupon.ordered.actual.page(params[:page]).per(12)
  end
end
