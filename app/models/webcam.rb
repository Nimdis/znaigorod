# encoding: utf-8

class Webcam < ActiveRecord::Base

  attr_accessible :kind, :title, :slug, :url, :parameters, :cab, :width, :height,
                  :address, :latitude, :longitude, :state, :snapshot_url, :snapshot_image


  validates_presence_of :kind, :title, :url, :width, :height,
                        :address, :latitude, :longitude

  scope :ordered, -> by { order by }

  scope :published, -> { where(:state => true) }

  extend FriendlyId
  friendly_id :title, use: :slugged

  extend Enumerize
  enumerize :kind, in: [:webcam_jw, :webcam_uppod, :webcam_axis, :webcam_swf]

  default_value_for :state, true

  has_attached_file :snapshot_image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  validates_attachment :snapshot_image, :content_type => {
    :content_type => ['image/jpeg', 'image/jpg', 'image/png'],
    :message => 'Изображение должно быть в формате jpeg, jpg или png'
  }

  def self.snapshot_href_for_index
    'http://storage.openteam.ru/files/38716/640-480/webcams.jpg'
  end

  def snapshot_href
    return self.class.snapshot_href_for_index unless snapshot_image_url?

    snapshot_image_url
  end

end

# == Schema Information
#
# Table name: webcams
#
#  id                          :integer          not null, primary key
#  kind                        :string(255)
#  title                       :text
#  slug                        :text
#  url                         :text
#  parameters                  :text
#  cab                         :text
#  width                       :integer
#  height                      :integer
#  address                     :text
#  latitude                    :string(255)
#  longitude                   :string(255)
#  state                       :boolean
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  snapshot_url                :text
#  snapshot_image_file_name    :string(255)
#  snapshot_image_content_type :string(255)
#  snapshot_image_file_size    :integer
#  snapshot_image_updated_at   :datetime
#  snapshot_image_url          :text
#

