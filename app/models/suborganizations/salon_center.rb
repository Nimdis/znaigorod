# encoding: utf-8

class SalonCenter < ActiveRecord::Base
  include HasVirtualTour
  include HasServices

  attr_accessible :category, :description, :feature, :offer, :title

  belongs_to :organization

  delegate :address, :phone, :latitude, :longitude, :to => :organization
  delegate :title, :to => :organization, :prefix => true

  # OPTIMIZE: <--- similar code
  attr_accessor :vfs_path
  attr_accessible :vfs_path
  def vfs_path
    "#{organization.vfs_path}/#{self.class.name.underscore}"
  end
  has_many :gallery_images, :as => :attachable, :dependent => :destroy

  # similar code --->

  include PresentsAsCheckboxes

  presents_as_checkboxes :category
  presents_as_checkboxes :feature
  presents_as_checkboxes :offer

  include SearchWithFacets

  search_with_facets :category, :feature, :offer

  include SmsClaims
end

# == Schema Information
#
# Table name: salon_centers
#
#  id              :integer          not null, primary key
#  category        :text
#  description     :text
#  feature         :text
#  title           :string(255)
#  offer           :text
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

