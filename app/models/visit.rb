# encoding: utf-8

class Visit < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :visitable, :polymorphic => true
  belongs_to :user

  has_many :messages, :as => :messageable, :dependent => :destroy

  validate :authenticated_user

  scope :rendereable,       -> { where(:visitable_type => ['Afisha', 'Organization']) }
  scope :inviter,           -> { where('acts_as_inviter IS NOT NULL') }
  scope :invited,           -> { where('acts_as_invited IS NOT NULL') }

  def actual?
    if self.visitable.is_a?(Afisha)
      self.visitable.actual?
    else
      true
    end
  end

  private

  def authenticated_user
    errors.add :user_id, 'Вы не зарегистрированы' if user.nil?
  end
end

# == Schema Information
#
# Table name: visits
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  visitable_id   :integer
#  visitable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

