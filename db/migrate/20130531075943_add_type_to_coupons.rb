class AddTypeToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :type, :string

    Coupon.where(:type => nil).update_all :type => 'PaidCoupon'
  end
end
