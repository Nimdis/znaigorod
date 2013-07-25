class Account < ActiveRecord::Base
  acts_as_follower
  acts_as_followable

  attr_accessible :email, :first_name, :last_name, :patronymic, :rating, :nickname, :location
  has_many :users

  scope :ordered, -> { order('ID ASC') }
end
