class Meal < ActiveRecord::Base
  include HasVirtualTour
  include HasServices

  attr_accessible :category, :cuisine, :feature, :offer, :payment, :title, :description

  belongs_to :organization

  delegate :address, :phone, :schedules, :halls, :site?, :site,
    :email?, :email, :affiches, :nearest_affiches,
    to: :organization

  delegate :title, :description, :description?, to: :organization, prefix: true

  validates_presence_of :organization_id

  delegate :save, to: :organization, prefix: true
  after_save :organization_save

  # OPTIMIZE: < --- similar code
  attr_accessor :vfs_path
  attr_accessible :vfs_path

  def vfs_path
    "#{organization.vfs_path}/#{self.class.name.underscore}"
  end

  has_many :images, :as => :imageable, :dependent => :destroy
  has_many :menus, :dependent => :destroy

  def sunspot_index
    index
  end
  # similar code --->

  include Rating

  include PresentsAsCheckboxes

  presents_as_checkboxes :category,
    :validates_presence => true,
    :message => I18n.t('activerecord.errors.messages.at_least_one_value_should_be_checked')

  presents_as_checkboxes :cuisine
  presents_as_checkboxes :feature
  presents_as_checkboxes :offer

  include SearchWithFacets

  search_with_facets :category, :payment, :cuisine, :feature, :offer, :stuff
end

# == Schema Information
#
# Table name: meals
#
#  id              :integer          not null, primary key
#  category        :text
#  feature         :text
#  offer           :text
#  payment         :string(255)
#  cuisine         :text
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string(255)
#  description     :text
#

