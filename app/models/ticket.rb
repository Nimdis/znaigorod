class Ticket < ActiveRecord::Base
  attr_accessible :number, :original_price, :price

  belongs_to :affiche

  validates_presence_of :number, :original_price, :price
end
