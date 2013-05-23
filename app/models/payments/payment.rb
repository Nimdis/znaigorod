class Payment < ActiveRecord::Base
  extend Enumerize

  belongs_to :paymentable, :polymorphic => true
  belongs_to :user

  after_initialize :set_state_to_penging

  enumerize :state, :in => [:pending, :approved, :canceled]

  def approve!
    self.state = 'approved'
    self.save :validate => false
  end

  def cancel!
    self.state = 'canceled'
    self.save! :validate => false
  end

  private

  def set_state_to_penging
    self.state = 'pending' if new_record?
  end
end

# == Schema Information
#
# Table name: payments
#
#  id               :integer          not null, primary key
#  paymentable_id   :integer
#  number           :integer
#  phone            :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  paymentable_type :string(255)
#  type             :string(255)
#  amount           :float
#  details          :text
#  state            :string(255)
#

