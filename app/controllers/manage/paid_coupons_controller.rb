class Manage::PaidCouponsController < Manage::ApplicationController
  has_scope :page, default: 1

  def index
    @state = state = params[:state].present? ? params[:state] : nil
    page = params[:page].to_i.zero? ? 1 : params[:page]

    search = Copy.search(:include => :copyable) {
      group :copyable_id_str
      order_by :id, :desc
      paginate :page => page, :per_page => 10
      with :copyable_type, 'Coupon'
      with :state, state if state.present?
    }

    @groups = search.group(:copyable_id_str).groups
    @paid_coupons = PaidCoupon.where(:id => @groups.map(&:value)).order('id DESC')
  end
end
