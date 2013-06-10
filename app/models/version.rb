class Version < ActiveRecord::Base
  attr_accessible :body

  belongs_to :versionable, :polymorphic => true
end
