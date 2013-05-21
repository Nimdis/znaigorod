class CouponsController < ApplicationController
  has_scope :page, default: 1

  def index
    @coupons = Coupon.available.page(params[:page]).per(12)
    render partial: 'coupons_list', layout: false and return if request.xhr?
  end
end
