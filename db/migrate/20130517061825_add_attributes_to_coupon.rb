class AddAttributesToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :place, :string
    add_column :coupons, :count, :integer
    add_column :coupons, :stale_at, :datetime
    add_column :coupons, :complete_at, :datetime
  end
end
