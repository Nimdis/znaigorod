class AddAffiliateUrlToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :affiliate_url, :text
  end
end
