# encoding: utf-8

class Visit < ActiveRecord::Base
  attr_accessible :user_id, :inviter_gender, :invited_gender, :acts_as_inviter, :acts_as_invited, :inviter_description, :invited_description

  belongs_to :visitable, :polymorphic => true
  belongs_to :user

  has_many :messages, :as => :messageable, :dependent => :destroy

  validate :authenticated_user

  scope :rendereable,      -> { where(:visitable_type => ['Afisha', 'Organization']) }

  extend Enumerize
  enumerize :inviter_gender, in: [:all, :male, :female], default: :all, predicates: true
  enumerize :invited_gender, in: [:all, :male, :female], default: :all, predicates: true

  private

  def authenticated_user
    #errors.add :visited, 'Вы не зарегистрированы' if user.nil?
  end
end

# == Schema Information
#
# Table name: visits
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  visitable_id        :integer
#  visitable_type      :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  acts_as_inviter     :boolean
#  acts_as_invited     :boolean
#  inviter_description :text
#  invited_description :text
#  invited_gender      :string(255)
#  inviter_gender      :string(255)
#

