class Manage::AffiliateCouponsController < Manage::ApplicationController
  skip_load_and_authorize_resource
  skip_authorization_check
  def index
    @coupons = Coupon.affiliated
  end
end
