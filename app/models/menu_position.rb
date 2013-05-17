class MenuPosition < ActiveRecord::Base

  attr_accessible :count, :description, :position, :price, :title, :cooking_time, :image, :delete_image

  validates_presence_of :title, :price

  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  delegate :clear, :to => :image, :allow_nil => true, :prefix => true

  attr_accessor :delete_image

  belongs_to :menu, :autosave => true

  def image_destroy
    self.image.destroy
    self.image_url = nil
  end

end

# == Schema Information
#
# Table name: menu_positions
#
#  id                 :integer          not null, primary key
#  menu_id            :integer
#  position           :string(255)
#  title              :string(255)
#  description        :text
#  price              :string(255)
#  count              :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  cooking_time       :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  image_url          :text
#

