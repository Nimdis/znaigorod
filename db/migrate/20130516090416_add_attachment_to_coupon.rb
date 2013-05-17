class AddAttachmentToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :image_file_name, :string
    add_column :coupons, :image_content_type, :string
    add_column :coupons, :image_file_size, :integer
    add_column :coupons, :image_updated_at, :datetime
    add_column :coupons, :image_url, :text
  end
end
