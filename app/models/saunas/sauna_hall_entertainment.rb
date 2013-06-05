# encoding: utf-8

class SaunaHallEntertainment < ActiveRecord::Base
  include UsefulAttributes

  attr_accessible :aerohockey, :billiard, :ping_pong,
                  :hookah, :karaoke, :tv, :guitar,
                  :checkers, :chess, :backgammon

  belongs_to :sauna_hall
end

# == Schema Information
#
# Table name: sauna_hall_entertainments
#
#  id            :integer          not null, primary key
#  sauna_hall_id :integer
#  karaoke       :integer
#  tv            :integer
#  billiard      :integer
#  ping_pong     :integer
#  hookah        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  aerohockey    :integer
#  checkers      :integer
#  chess         :integer
#  backgammon    :integer
#  guitar        :integer
#

