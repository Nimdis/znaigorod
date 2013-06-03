class Manage::CouponsController < Manage::ApplicationController
  skip_load_resource
  before_filter :set_type_and_class, :on => [:new, :create, :update]

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
    @coupon = @klass.new(params[:coupon])

    if @coupon.save
      redirect_to manage_coupon_path(@coupon)
    else
      render :new
    end
  end

  def show
    @coupon = Coupon.find(params[:id])
  end

  def update
    @coupon = @klass.find(params[:id])

    if @coupon.update_attributes(params[:coupon])
      redirect_to manage_coupon_path(@coupon)
    else
      render :edit
    end
  end

  private

  def set_type_and_class
    @type = params[:type]
    @klass = "#{@type}_coupon".classify.constantize
  end
end
