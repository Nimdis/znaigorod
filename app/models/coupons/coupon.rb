class Coupon < ActiveRecord::Base
  attr_accessible :description, :discount, :title, :organization_id, :offers_attributes, :vfs_path

  belongs_to :organization
  has_many :offers, dependent: :destroy
  accepts_nested_attributes_for :offers, allow_destroy: true

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
