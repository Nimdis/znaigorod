# encoding: utf-8

class SaunaStuff < ActiveRecord::Base
  include UsefulAttributes

  attr_accessible :safe, :wifi

  belongs_to :sauna
end

# == Schema Information
#
# Table name: sauna_stuffs
#
#  id         :integer          not null, primary key
#  sauna_id   :integer
#  wifi       :integer
#  safe       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

