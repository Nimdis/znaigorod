class CouponsController < ApplicationController
  has_scope :page, default: 1

  def index
    @coupons = Coupon.ordered.available.page(params[:page]).per(12)
    render partial: 'coupons_list', :locals => { :collection => @coupons }, layout: false and return if request.xhr?
  end

  def show
    @coupon= Coupon.find(params[:id])
  end
end
