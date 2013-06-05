# encoding: utf-8

class SaunaHallBath < ActiveRecord::Base
  include UsefulAttributes

  attr_accessible :finnish, :infrared, :japanese, :russian, :turkish

  belongs_to :sauna_hall
end

# == Schema Information
#
# Table name: sauna_hall_baths
#
#  id            :integer          not null, primary key
#  sauna_hall_id :integer
#  russian       :boolean
#  finnish       :boolean
#  turkish       :boolean
#  japanese      :boolean
#  infrared      :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

