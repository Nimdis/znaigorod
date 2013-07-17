# encoding: utf-8

class Sauna < ActiveRecord::Base
  include HasVirtualTour

  attr_accessible :category, :feature, :offer, :payment, :title, :description

  belongs_to :organization

  delegate :address, :phone, :schedules, :halls,
           :site?, :site, :email?, :email, :afisha,
           :latitude, :longitude, :nearest_afisha, :to => :organization

  delegate :title, :description, :description?, to: :organization, prefix: true

  validates_presence_of :organization_id

  delegate :save, to: :organization, prefix: true
  after_save :organization_save

  # OPTIMIZE: <--- similar code
  attr_accessor :vfs_path
  attr_accessible :vfs_path
  def vfs_path
    "#{organization.vfs_path}/#{self.class.name.underscore}"
  end
  has_many :gallery_images, :as => :attachable, :dependent => :destroy
  # similar code --->

  def sunspot_index
    index and sauna_halls.map(&:index)
  end


  attr_accessible :sauna_accessory_attributes, :sauna_alcohol_attributes,
    :sauna_broom_attributes, :sauna_massage_attributes,
    :sauna_oil_attributes, :sauna_stuff_attributes,
    :sauna_child_stuff_attributes

  has_many :sauna_halls, :dependent => :destroy

  def ordered_sauna_halls
    sauna_halls.sort_by(&:min_sauna_hall_schedules_price)
  end

  has_one :sauna_accessory,   :dependent => :destroy
  has_one :sauna_broom,       :dependent => :destroy
  has_one :sauna_alcohol,     :dependent => :destroy
  has_one :sauna_oil,         :dependent => :destroy
  has_one :sauna_child_stuff, :dependent => :destroy
  has_one :sauna_stuff,       :dependent => :destroy
  has_one :sauna_massage,     :dependent => :destroy

  accepts_nested_attributes_for :sauna_accessory
  accepts_nested_attributes_for :sauna_broom
  accepts_nested_attributes_for :sauna_alcohol
  accepts_nested_attributes_for :sauna_oil
  accepts_nested_attributes_for :sauna_child_stuff
  accepts_nested_attributes_for :sauna_stuff
  accepts_nested_attributes_for :sauna_massage

  include Rating

  use_for_rating :sauna_halls, :sauna_accessory, :sauna_broom, :sauna_alcohol, :sauna_oil, :sauna_child_stuff, :sauna_stuff, :sauna_massage

  include PresentsAsCheckboxes

  presents_as_checkboxes :category, :default_value => Values.instance.sauna.categories

  presents_as_checkboxes :feature
  presents_as_checkboxes :offer

  include SearchWithFacets

  search_with_facets :category, :payment, :feature, :offer, :stuff

  def with_sauna_halls?
    sauna_halls.any?
  end

  include SmsClaims
end

# == Schema Information
#
# Table name: saunas
#
#  id              :integer          not null, primary key
#  category        :text
#  feature         :text
#  offer           :text
#  payment         :string(255)
#  organization_id :integer
#  title           :string(255)
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

