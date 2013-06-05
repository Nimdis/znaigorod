# encoding: utf-8

class SaunaMassage < ActiveRecord::Base
  include UsefulAttributes

  attr_accessible :anticelltilitis, :classical, :spa

  belongs_to :sauna
end

# == Schema Information
#
# Table name: sauna_massages
#
#  id              :integer          not null, primary key
#  sauna_id        :integer
#  classical       :integer
#  spa             :integer
#  anticelltilitis :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

