class MenuPosition < ActiveRecord::Base
  attr_accessible :count, :description, :position, :price, :title, :cooking_time

  belongs_to :menu
end
