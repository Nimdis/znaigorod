# encoding: utf-8

class UserRating < ActiveRecord::Base
  attr_accessible :value

  belongs_to :user
  belongs_to :rateable, :polymorphic => true

  validates :value, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 4  }
  validates :rateable, :presence => true
  validate :authenticated_user
  validates :user_id, :uniqueness => { :scope => [:rateable_id, :rateable_type] }

  after_save :rateable_recalculate_rating

  private

    delegate :recalculate_rating, :to => :rateable, :prefix => true

    def authenticated_user
      errors.add :value, 'Оценивать могут только зарегистрированные пользователи.' if user.nil?
    end
end

# == Schema Information
#
# Table name: user_ratings
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  rateable_id   :integer
#  rateable_type :string(255)
#  value         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

