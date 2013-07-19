require 'active_support/concern'

module AfishaQualityRating
  extend ActiveSupport::Concern

  include Rateable

  def calculate_afisha_total_rating
    user_rating - (user_rating - quality_rating) / (user_ratings.count + 1)**((user_ratings.count * 0.02)/(user_rating + 0.1))
  end

  private

  def quality_rating
    @quality_rating ||= 0.8*organization_rating + 0.2*images_rating
  end

  def organization_rating
    organizations.average(:total_rating) || 0.7
  end

  def images_rating
    [images.count, 10].min * 0.1
  end
end
