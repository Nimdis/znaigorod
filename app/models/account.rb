class Account < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :patronymic, :rating, :nickname, :location
  has_many :users
end
