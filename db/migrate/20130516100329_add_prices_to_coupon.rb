class AddPricesToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :price_with_discount, :integer
    add_column :coupons, :price_without_discount, :integer
    add_column :coupons, :organization_quota, :integer
    add_column :coupons, :price, :integer
    add_column :coupons, :kind, :string
  end
end
