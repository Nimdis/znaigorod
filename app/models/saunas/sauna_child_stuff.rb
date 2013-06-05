# encoding: utf-8

class SaunaChildStuff < ActiveRecord::Base
  include UsefulAttributes

  attr_accessible :cartoons, :games, :life_jacket, :rubber_ring

  belongs_to :sauna
end

# == Schema Information
#
# Table name: sauna_child_stuffs
#
#  id          :integer          not null, primary key
#  sauna_id    :integer
#  life_jacket :integer
#  cartoons    :integer
#  games       :integer
#  rubber_ring :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

