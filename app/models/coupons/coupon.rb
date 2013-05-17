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
#  id                     :integer          not null, primary key
#  title                  :string(255)
#  description            :text
#  discount               :integer
#  vfs_path               :string(255)
#  organization_id        :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  image_file_name        :string(255)
#  image_content_type     :string(255)
#  image_file_size        :integer
#  image_updated_at       :datetime
#  image_url              :text
#  price_with_discount    :integer
#  price_without_discount :integer
#  organization_quota     :integer
#  price                  :integer
#  kind                   :string(255)
#

