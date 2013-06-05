# encoding: utf-8

class Menu < ActiveRecord::Base

  attr_accessible :category, :description, :menu_positions_attributes

  belongs_to :meal

  has_many :menu_positions, autosave: true, dependent: :destroy

  accepts_nested_attributes_for :menu_positions, allow_destroy: true

end

# == Schema Information
#
# Table name: menus
#
#  id          :integer          not null, primary key
#  meal_id     :integer
#  category    :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

