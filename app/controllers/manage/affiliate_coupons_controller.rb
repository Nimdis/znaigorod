class Manage::AffiliateCouponsController < Manage::ApplicationController
  has_scope :page, default: 1

  def index
    @category = category = params[:category].present? ? params[:category] : nil
    page = params[:page].to_i.zero? ? 1 : params[:page]

    search = AffiliateCoupon.search {
      paginate :page => page, :per_page => 10
      with :suborganizations_kind, category if category.present?
    }
    @affiliate_coupons = search.results
  end
end
