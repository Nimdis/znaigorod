# encoding: utf-8

class SaunaAlcohol < ActiveRecord::Base
  include UsefulAttributes

  attr_accessible :ability_own, :sale

  belongs_to :sauna
end

# == Schema Information
#
# Table name: sauna_alcohols
#
#  id          :integer          not null, primary key
#  sauna_id    :integer
#  ability_own :integer
#  sale        :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

