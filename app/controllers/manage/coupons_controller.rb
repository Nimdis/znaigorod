class Manage::CouponsController < Manage::ApplicationController
  before_filter :set_type_and_class, :on => [:new, :create]

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
    @coupons = PaidCoupon.where(:id => @groups.map(&:value)).order('id DESC')
  end

  def new
    @coupon = @klass.new
  end

  def create
    @coupon = @klass.new(params["#{@type}_coupon"])

    if @coupon.save
      redirect_to [:manage, @coupon]
    else
      render :new
    end
  end

  private

  def set_type_and_class
    @type = params[:type]
    @klass = "#{@type}_coupon".classify.constantize
  end
end
