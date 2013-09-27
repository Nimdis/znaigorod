# encoding: utf-8

class Webcam < ActiveRecord::Base

  attr_accessible :kind, :title, :slug, :url, :parameters, :cab, :width, :height,
                  :address, :latitude, :longitude, :state


  validates_presence_of :kind, :title, :url, :width, :height,
                        :address, :latitude, :longitude

  scope :ordered, order(:title)

  scope :published, -> { where(:state => true) }

  extend FriendlyId
  friendly_id :title, use: :slugged

  extend Enumerize
  enumerize :kind, in: [:webcam_jw, :webcam_uppod, :webcam_axis, :webcam_swf]

  default_value_for :state, true

end

# == Schema Information
#
# Table name: webcams
#
#  id         :integer          not null, primary key
#  kind       :string(255)
#  title      :text
#  slug       :text
#  url        :text
#  parameters :text
#  cab        :text
#  width      :integer
#  height     :integer
#  address    :text
#  latitude   :string(255)
#  longitude  :string(255)
#  state      :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

