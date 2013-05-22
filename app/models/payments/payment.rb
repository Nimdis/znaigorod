class Payment < ActiveRecord::Base
  belongs_to :paymentable, :polymorphic => true
  belongs_to :user

  def approve
  end
end
