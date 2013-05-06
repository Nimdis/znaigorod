class Menu < ActiveRecord::Base

  attr_accessible :category, :description, :menu_positions_attributes

  belongs_to :meal

  has_many :menu_positions, autosave: true, dependent: :destroy

  accepts_nested_attributes_for :menu_positions, allow_destroy: true

end
