class Coupon < ActiveRecord::Base
  include Copies

  extend Enumerize

  attr_accessible :description, :discount, :title, :organization_id, :price_with_discount,
                  :price_without_discount, :price, :organization_quota,
                  :kind, :image, :delete_image, :place, :vfs_path,
                  :number, :stale_at, :complete_at, :categories, :affiliate_url

  attr_accessor :delete_image

  scope :ordered, -> { order('created_at DESC') }
  scope :affiliated, -> { where('affiliate_url IS NOT NULL') }

  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  delegate :clear, :to => :image, :allow_nil => true, :prefix => true

  before_save :set_discount
  before_update :image_destroy

  belongs_to :organization

  has_many :votes, :as => :voteable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy

  enumerize :kind, in: [:certificate, :coupon], predicates: true
  serialize :categories, Array
  enumerize :categories, in: Organization.available_suborganization_kinds.map(&:to_sym), multiple: true

  validates_presence_of :categories, :image, :kind, :place, :stale_at

  def self.generate_vfs_path
    "/znaigorod/coupons/#{Time.now.strftime('%Y/%m/%d/%H-%M')}-#{SecureRandom.hex(4)}"
  end

  def get_organization_id
    self.try(:organization_id)
  end

  def random_coupons
    self.class.where('id != ?', self.id).limit(100).sample(4)
  end

  searchable do
    string(:suborganizations_kind, :multiple => true) { organization.suborganizations.map(&:class).map(&:name).map(&:underscore) }
  end

  private

  def image_destroy
    if self.delete_image
      self.image.destroy
      self.image_url = nil
    end
  end

  def set_discount
    if self.price_without_discount? & self.price_with_discount?
      self.discount = ((self.price_without_discount - self.price_with_discount) * 100 / price_without_discount).round
    end
  end

  def create_copies
    super unless affiliate_url?
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
#  place                  :string(255)
#  count                  :integer
#  stale_at               :datetime
#  complete_at            :datetime
#

