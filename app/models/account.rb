class Account < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :patronymic, :rating
  has_many :users
end
