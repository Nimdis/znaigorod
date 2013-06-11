class Version < ActiveRecord::Base
  extend HTMLDiff

  attr_accessible :body
  serialize :body, JSON

  belongs_to :versionable, :polymorphic => true

  def what_changed
    JSON.parse(self.body)
  end
end
