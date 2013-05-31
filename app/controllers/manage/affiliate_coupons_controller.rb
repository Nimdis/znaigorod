class Manage::AffiliateCouponsController < Manage::ApplicationController
  has_scope :page, default: 1

  skip_load_and_authorize_resource
  skip_authorization_check
  def index
    @coupons = Coupon.affiliated.page(params[:page]).per(12)
  end
end
