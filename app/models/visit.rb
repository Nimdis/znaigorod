# encoding: utf-8

class Visit < ActiveRecord::Base
  attr_accessible :visited, :user_id, :gender, :acts_as, :description

  belongs_to :visitable, :polymorphic => true
  belongs_to :user

  has_many :messages, :as => :messageable, :dependent => :destroy

  validate :authenticated_user

  scope :visited, -> { where(:visited => true) }
  scope :wanted_to, ->(act) { where('acts_as = ?', act) }

  extend Enumerize
  enumerize :gender, in: [:all, :male, :female], default: :all, predicates: true
  enumerize :acts_as, in: [:inviter, :invited], predicates: true

  def change_visit
    self.visited = !visited?
    self.save
  end

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

