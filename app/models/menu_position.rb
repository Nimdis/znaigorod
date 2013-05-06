class MenuPosition < ActiveRecord::Base
  attr_accessible :count, :description, :position, :price, :title, :cooking_time, :image

  validates_presence_of :title, :price

  belongs_to :menu

  has_attached_file :image, :storage => :elvfs, :elvfs_url => Settings['storage.url']
end
