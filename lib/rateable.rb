require 'active_support/concern'

module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :user_ratings, :as => :rateable
    after_save :recalculate_rating
    scope :ordered_by_rating, -> { order(:total_rating) }
  end

  def recalculate_rating
    update_column(:total_rating, calculate_total_rating)
  end

  def recalculate_afisha_rating
    update_column(:total_rating, calculate_afisha_total_rating)
  end

  private

  def calculate_total_rating
    user_rating - (user_rating - quality_rating) / (user_ratings.count + 1)**((user_ratings.count * 0.02)/(user_rating + 0.1))
  end

  def user_rating
    @user_rating ||= user_ratings.average(:value).to_i / 4.0
  end
end
