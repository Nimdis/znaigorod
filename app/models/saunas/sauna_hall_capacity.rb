# encoding: utf-8

class SaunaHallCapacity < ActiveRecord::Base
  include UsefulAttributes

  attr_accessible :default, :maximal, :extra_guest_cost

  belongs_to :sauna_hall
end

# == Schema Information
#
# Table name: sauna_hall_capacities
#
#  id               :integer          not null, primary key
#  sauna_hall_id    :integer
#  default          :integer
#  maximal          :integer
#  extra_guest_cost :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

