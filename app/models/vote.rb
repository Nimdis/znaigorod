# encoding: utf-8

class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, :polymorphic => true
  attr_accessible :like, :user_id

  has_many :messages, :as => :messageable, :dependent => :destroy

  validate :authenticated_user

  scope :liked, where(:like => true)

  after_save :update_voteable_rating

  def change_vote
    self.like = (like? ? false : true)
    self.save
  end

  private
    def authenticated_user
      errors.add :like, 'может быть оставлена только зарегистрированным пользователем' if user.nil?
    end

    def update_voteable_rating
      voteable.update_rating if (Afisha.kind.values & voteable.kind).any?
    end
end

# == Schema Information
#
# Table name: votes
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  like          :boolean          default(FALSE)
#  voteable_id   :integer
#  voteable_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

