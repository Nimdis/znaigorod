# encoding: utf-8

class PoolTablePrice < ActiveRecord::Base
  attr_accessible :day, :from, :price, :to

  belongs_to :pool_table

  default_scope order('day, pool_table_prices.from')

  default_value_for :day, 1

  def to_s
    "#{day} #{from} #{to} #{price}"
  end
end

# == Schema Information
#
# Table name: pool_table_prices
#
#  id            :integer          not null, primary key
#  pool_table_id :integer
#  day           :integer
#  from          :time
#  to            :time
#  price         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

