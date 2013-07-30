# encoding: utf-8

class Visit < ActiveRecord::Base
  attr_accessible :visited, :user_id

  belongs_to :visitable, :polymorphic => true
  belongs_to :user

  has_many :messages, :as => :messageable, :dependent => :destroy

  validate :authenticated_user

  scope :visited, where(:visited => true)

  after_save :update_visitable_rating

  def change_visit
    self.visited = !visited?
    self.save
  end

  private

    def authenticated_user
      errors.add :visited, 'Вы не зарегистрированы' if user.nil?
    end

    def update_visitable_rating
      visitable.update_rating if visitable.is_a?(Afisha) && (Afisha.kind.values & visitable.kind).any?
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
#

