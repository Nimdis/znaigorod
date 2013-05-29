class AddCategoriesToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :categories, :text
  end
end
