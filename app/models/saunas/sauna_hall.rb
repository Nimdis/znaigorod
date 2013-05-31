class SaunaHall < ActiveRecord::Base
  # ActiveSupport::Concern extentions
  include UsefulAttributes
  include HasVirtualTour

  attr_accessible :title, :vfs_path, :description, :sauna_hall_schedules_attributes,
    :sauna_hall_bath_attributes, :sauna_hall_capacity_attributes, :sauna_hall_entertainment_attributes,
    :sauna_hall_interior_attributes, :sauna_hall_pool_attributes

  belongs_to :sauna

  has_many :gallery_images, :as => :attachable,  :dependent => :destroy
  has_many :sauna_hall_schedules,       :dependent => :destroy

  has_one :sauna_hall_bath, :dependent => :destroy
  has_one :sauna_hall_capacity, :dependent => :destroy
  has_one :sauna_hall_entertainment, :dependent => :destroy
  has_one :sauna_hall_interior, :dependent => :destroy
  has_one :sauna_hall_pool, :dependent => :destroy
  has_one :organization, :through => :sauna
  has_one :address, :through => :organization
  has_many :schedules, :through => :organization

  accepts_nested_attributes_for :sauna_hall_bath
  accepts_nested_attributes_for :sauna_hall_capacity
  accepts_nested_attributes_for :sauna_hall_entertainment
  accepts_nested_attributes_for :sauna_hall_interior
  accepts_nested_attributes_for :sauna_hall_pool
  accepts_nested_attributes_for :sauna_hall_schedules, :allow_destroy => true, :reject_if => :all_blank

  delegate :organization_title, :to => :sauna
  delegate :size, :to => :sauna_hall_pool, :prefix => :pool

  searchable do
    integer :capacity
    integer :price_max
    integer :price_min
    integer(:price) { price_min }

    float(:rating) { sauna.organization.total_rating }

    latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }

    string :baths,          :multiple => true
    string :features,       :multiple => true
    string :pool_features,  :multiple => true
    string :sauna_id
    string(:title) { organization_title }
  end

  include Rating
  use_for_rating :sauna_hall_bath, :sauna_hall_capacity, :sauna_hall_entertainment, :sauna_hall_interior, :sauna_hall_pool

  def summary_rating_with_images
    summary_rating_without_images + images.count
  end

  alias_method_chain :summary_rating, :images

  def capacity
    sauna_hall_capacity.maximal || sauna_hall_capacity.default
  end

  def min_sauna_hall_schedules_price
    sauna_hall_schedules.minimum(:price)
  end
  alias_method :price_min, :min_sauna_hall_schedules_price

  def max_sauna_hall_schedules_price
    sauna_hall_schedules.maximum(:price)
  end
  alias_method :price_max, :max_sauna_hall_schedules_price

  def latitude
    sauna.organization.latitude
  end

  def longitude
    sauna.organization.longitude
  end

  def filled?(value)
    !value.nil? && !!value && !value.blank?
  end

  def pool_features
    sauna_hall_pool.useful_attributes.select { |attribute|
      attribute if filled?(sauna_hall_pool.send(attribute))
    }.map { |attribute| sauna_hall_pool.class.human_attribute_name(attribute) }.
      map(&:mb_chars).
      map(&:downcase)
  end

  def baths
    sauna_hall_bath.useful_attributes.select { |attribute|
      attribute if filled?(sauna_hall_bath.send(attribute))
    }.map { |attribute| sauna_hall_bath.class.human_attribute_name(attribute) }.
      map(&:mb_chars).
      map(&:downcase)
  end

  def sauna_hall_entertainment_features
    sauna_hall_entertainment.useful_attributes.select { |attribute|
      attribute if filled?(sauna_hall_entertainment.send(attribute))
    }.map { |attribute| sauna_hall_entertainment.class.human_attribute_name(attribute) }.
      map(&:mb_chars).
      map(&:downcase)
  end

  def sauna_hall_interior_features
    sauna_hall_interior.useful_attributes.select { |attribute|
      attribute if filled?(sauna_hall_interior.send(attribute))
    }.map { |attribute| sauna_hall_interior.class.human_attribute_name(attribute) }.
      map(&:mb_chars).
      map(&:downcase)
  end

  def features
    features = sauna_hall_entertainment_features + sauna_hall_interior_features
    features << self.class.human_attribute_name(:virtual_tour_link).mb_chars.downcase if virtual_tour_link
    features
  end
end

# == Schema Information
#
# Table name: sauna_halls
#
#  id          :integer          not null, primary key
#  sauna_id    :integer
#  title       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  vfs_path    :text
#  description :text
#

