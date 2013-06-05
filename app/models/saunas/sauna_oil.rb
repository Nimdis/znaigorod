# encoding: utf-8

class SaunaOil < ActiveRecord::Base
  include UsefulAttributes

  attr_accessible :ability, :sale

  belongs_to :sauna
end

# == Schema Information
#
# Table name: sauna_oils
#
#  id         :integer          not null, primary key
#  sauna_id   :integer
#  ability    :integer
#  sale       :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

