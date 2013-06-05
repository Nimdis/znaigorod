# encoding: utf-8

class SaunaHallSchedule < ActiveRecord::Base
  attr_accessible :day, :from, :price, :to

  belongs_to :sauna_hall

  scope :ordered, -> { order('day, sauna_hall_schedules.from') }

  default_value_for :day, 1
end

# == Schema Information
#
# Table name: sauna_hall_schedules
#
#  id            :integer          not null, primary key
#  sauna_hall_id :integer
#  day           :integer
#  from          :time
#  to            :time
#  price         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

