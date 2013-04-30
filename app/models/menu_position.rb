class MenuPosition < ActiveRecord::Base
  attr_accessible :count, :description, :position, :price, :title, :cooking_time

  validates_presence_of :title, :price

  belongs_to :menu
end
