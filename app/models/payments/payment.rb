class Payment < ActiveRecord::Base
  extend Enumerize

  belongs_to :paymentable, :polymorphic => true
  belongs_to :user

  enumerize :state, :in => [:pending, :approved, :canceled], :default => :pending

  def approve!
    self.state = 'approved'
    self.save :validate => false
  end

  def cancel!
    self.state = 'canceled'
    self.save! :validate => false
  end
end
