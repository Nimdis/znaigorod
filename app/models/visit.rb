# encoding: utf-8

class Visit < ActiveRecord::Base
  attr_accessible :visited, :user_id, :inviter_gender, :invited_gender, :acts_as_inviter, :acts_as_invited, :inviter_description, :invited_description

  belongs_to :visitable, :polymorphic => true
  belongs_to :user

  has_many :messages, :as => :messageable, :dependent => :destroy

  validate :authenticated_user

  scope :visited, -> { where(:visited => true) }
  scope :rendereable,      -> { where(:visitable_type => ['Afisha', 'Organization']) }

  extend Enumerize
  enumerize :inviter_gender, in: [:all, :male, :female], default: :all, predicates: true
  enumerize :invited_gender, in: [:all, :male, :female], default: :all, predicates: true

  private

  def authenticated_user
    errors.add :visited, 'Вы не зарегистрированы' if user.nil?
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
#  visited        :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  gender         :string(255)
#  description    :text
#  acts_as        :string(255)
#

