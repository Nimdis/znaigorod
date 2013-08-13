# encoding: utf-8

class Sport < ActiveRecord::Base
  include HasVirtualTour
  include HasServices

  attr_accessible :services_attributes, :title, :description, :category, :feature

  belongs_to :organization

  delegate :address, :phone, :schedules, :halls,
           :site?, :site, :email?, :email, :afisha,
           :latitude, :longitude, :nearest_afisha, :to => :organization

  delegate :title, :description, :description?, :to => :organization, :prefix => true

  delegate :save, to: :organization, prefix: true
  after_save :organization_save

  # OPTIMIZE: <--- similar code
  attr_accessor :vfs_path
  attr_accessible :vfs_path
  def vfs_path
    "#{organization.vfs_path}/#{self.class.name.underscore}"
  end
  has_many :gallery_images, :as => :attachable, :dependent => :destroy

  def sunspot_index
    index
  end
  # similar code --->

  def category
    (@category || services.pluck(:category).compact.uniq).join(', ')
  end

  def feature
    (@feature || services.pluck(:feature).compact.uniq).join(', ')
  end

  def categories
    category.split(',').map(&:squish).uniq
  end

  def features
    feature.split(',').map(&:squish).uniq
  end

  include Rating

  include SearchWithFacets

  search_with_facets :category, :feature, :stuff

  include PresentsAsCheckboxes
  presents_as_checkboxes :category,
    :validates_presence => true,
    :message => I18n.t('activerecord.errors.messages.at_least_one_value_should_be_checked')
  presents_as_checkboxes :feature

end

# == Schema Information
#
# Table name: sports
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#  title           :string(255)
#  description     :text
#

