class MenuPosition < ActiveRecord::Base
  attr_accessible :count, :description, :position, :price, :title

  belongs_to :menu
end
