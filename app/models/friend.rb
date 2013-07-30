class Friend < ActiveRecord::Base
  attr_accessible :friendable, :account_id

  belongs_to :account
  belongs_to :friendable, :polymorphic => true
end
