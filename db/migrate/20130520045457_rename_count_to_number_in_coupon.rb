class RenameCountToNumberInCoupon < ActiveRecord::Migration
  def up
    rename_column :coupons, :count, :number
  end

  def down
    rename_column :coupons, :number, :count
  end
end
