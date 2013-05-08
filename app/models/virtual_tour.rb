class VirtualTour < ActiveRecord::Base
  attr_accessible :link, :attachment

  belongs_to :tourable, :polymorphic => true

  has_one :image, :as => :attacheable, :class_name => 'PaperclipAttachment', :conditions => { :attachment_type => :image }, :dependent => :destroy

  accepts_nested_attributes_for :image, :allow_destroy => true

  validates :link, :format => URI::regexp(%w(http https)), :presence => true

  normalize_attribute :link

  delegate :attachment, :attachment_url, :attachment_url?, :attachment=, :to => :image, :allow_nil => true

  def image
    super || build_image
  end
end

# == Schema Information
#
# Table name: virtual_tours
#
#  id            :integer          not null, primary key
#  link          :string(255)
#  tourable_id   :integer
#  tourable_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

