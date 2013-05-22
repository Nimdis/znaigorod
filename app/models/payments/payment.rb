class Payment < ActiveRecord::Base
  extend Enumerize

  belongs_to :paymentable, :polymorphic => true
  belongs_to :user

  after_initialize :set_state_to_penging

  enumerize :state, :in => [:pending, :approved]

  def approve!
    self.state = 'approved'
    self.save(:validate => false)
  end

  private

  def set_state_to_penging
    self.state = 'pending' if new_record?
  end
end
