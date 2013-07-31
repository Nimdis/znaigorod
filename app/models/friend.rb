class Friend < ActiveRecord::Base
  attr_accessible :friendly, :friendable, :account_id

  belongs_to :account
  belongs_to :friendable, :polymorphic => true

  scope :approved, -> { where(friendly: true) }

  def change_friendship
    self.friendly = !friendly?
    self.save
  end
end
