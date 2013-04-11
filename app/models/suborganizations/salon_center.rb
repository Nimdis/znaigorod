class SalonCenter < ActiveRecord::Base
  include HasVirtualTour
  include HasServices

  attr_accessible :category, :description, :feature, :offer, :title, :services_attributes

  belongs_to :organization

  delegate :address, :phone, :latitude, :longitude, :to => :organization
  delegate :title, :to => :organization, :prefix => true

  has_many :services, :as => :context, :dependent => :destroy, :order => 'id'
  validates_associated :services
  accepts_nested_attributes_for :services, :reject_if => :all_blank, :allow_destroy =>  true

  # OPTIMIZE: <--- similar code
  attr_accessor :vfs_path
  attr_accessible :vfs_path
  def vfs_path
    "#{organization.vfs_path}/#{self.class.name.underscore}"
  end
  has_many :images, :as => :imageable, :dependent => :destroy

  def sunspot_index
    index
  end
  # similar code --->

  include PresentsAsCheckboxes

  presents_as_checkboxes :category
  presents_as_checkboxes :feature
  presents_as_checkboxes :offer

  include SearchWithFacets

  search_with_facets :category, :feature, :offer
end

