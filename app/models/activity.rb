class Activity < ActiveRecord::Base
  attr_accessible :title

  belongs_to :organization
  belongs_to :user
end
