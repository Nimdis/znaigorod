class Coupon < ActiveRecord::Base

  attr_accessible :description, :discount, :title, :organization_id, :price_with_discount, :price_without_discount, :price, :organization_quota, :kind, :image, :delete_image, :vfs_path

  attr_accessor :delete_image

  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  delegate :clear, :to => :image, :allow_nil => true, :prefix => true

  before_update :image_destroy

  belongs_to :organization

  def image_destroy
    if self.delete_image
      self.image.destroy
      self.image_url = nil
    end
  end

  def self.generate_vfs_path
    "/znaigorod/coupons/#{Time.now.strftime('%Y/%m/%d/%H-%M')}-#{SecureRandom.hex(4)}"
  end
end

# == Schema Information
#
# Table name: coupons
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  discount    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

