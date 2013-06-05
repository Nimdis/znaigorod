class Coupon < ActiveRecord::Base
  extend Enumerize

  attr_accessible :description, :discount, :title, :organization_id,
                  :kind, :image, :delete_image, :place,
                  :stale_at, :complete_at, :categories

  belongs_to :organization

  attr_accessor :delete_image
  delegate :clear, :to => :image, :allow_nil => true, :prefix => true
  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  before_update :image_destroy

  serialize :categories, Array
  enumerize :categories, in: Organization.available_suborganization_kinds.map(&:to_sym), multiple: true

  enumerize :kind, in: [:certificate, :coupon], predicates: true

  has_many :votes, :as => :voteable, :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy

  scope :ordered,   -> { order 'created_at DESC' }
  scope :actual,    -> { where 'stale_at > ?', Time.zone.now }
  scope :stale,     -> { where 'stale_at <= ?', Time.zone.now }

  validates_presence_of :categories, :image, :kind, :stale_at

  def get_organization_id
    self.try(:organization_id)
  end

  def random_coupons
    self.class.where('id != ?', self.id).limit(100).sample(4)
  end

  def self.ordered_descendants
    [AffiliateCoupon, DiscountCoupon, FreeCoupon, PaidCoupon]
  end

  searchable do
    string :suborganizations_kind, :multiple => true
    text(:description_ru) { [title, description].join(' ') } 
  end

  private

  def suborganizations_kind
    return [] unless organization

    organization.suborganizations.map(&:class).map(&:name).map(&:underscore)
  end

  def image_destroy
    if self.delete_image
      self.image.destroy
      self.image_url = nil
    end
  end
end
