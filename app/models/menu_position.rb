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
