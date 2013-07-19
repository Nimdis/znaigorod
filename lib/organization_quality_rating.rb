require 'active_support/concern'

module OrganizationQualityRating
  extend ActiveSupport::Concern

  include Rateable

  def quality_rating
    @quality_rating ||= 0.8*fullness_rating + 0.1*afisha_rating + 0.05*images_rating + 0.05*sauna_hall_images_rating
  end

  def fullness_rating
    sum = 0
    sum += calculate_fullness_rating(self)
    self.suborganizations.each do |suborganization|
      sum += calculate_fullness_rating(suborganization)
    end

    sum /= (suborganizations.count + 1)
    sum
  end

  private

  def afisha_rating
    [nearest_afisha.count, 2].min * 0.5
  end

  def images_rating
    [images.count, 10].min * 0.1
  end

  def sauna_hall_images_rating
    images = 0
    self.suborganizations.each do |suborganization|
      if suborganization.is_a?(Sauna)
        suborganization.sauna_halls.each do |sauna_hall|
          images += [sauna_hall.images.count, 5].min * 0.2
        end
        images /= (suborganization.sauna_halls.any? ? suborganization.sauna_halls.count : 1)
      end
    end

    images < 1 ? 1 : images
  end

  def sauna_fullness_rating
    sum = 0
    sum += calculate_fullness_rating(self)
    hall_count = 11
    self.suborganizations.each do |suborganization|
      sum += calculate_fullness_rating(suborganization)

      if suborganization.is_a?(Sauna)
        hall_count += suborganization.sauna_halls.count

        associations = Sauna.reflect_on_all_associations(:has_one).map(&:name) - [:virtual_tour, :sauna_stuff, :sauna_massage]

        associations.each do |association|
          sum += calculate_fullness_rating(suborganization.send(association))
        end

        suborganization.sauna_halls.each do |sauna_hall|
          associations = SaunaHall.reflect_on_all_associations(:has_one).map(&:name) - [:address, :organization, :virtual_tour]
          associations.each do |association|
            sum += calculate_fullness_rating(sauna_hall.send(association))
          end
        end
      end
    end

    sum /= (suborganizations.count + hall_count + 1)
  end

  def calculate_fullness_rating(object)
    filled_attributes = object.attributes.select{|k,v| !v.nil? && v.to_s.present?}
    hash = send("#{object.class.name.underscore}_hash")
    sum = filled_attributes.inject(0) { |sum, obj| sum += hash[obj.first].to_f; sum }

    sum += hash["virtual_tour"] if object.virtual_tour.link?

    sum.to_f / hash.values.inject(:+)
  end

  def organization_hash
    { "email" => 0.3, "logotype_url" => 1, "non_cash" => 0.5, "phone" => 0.5, "subdomain" => 1, "virtual_tour" => 1 }
  end

  def meal_hash
    { "feature" => 0.2, "offer" => 0.5, "cuisine" => 1, "virtual_tour" => 0.01 }
  end

  def entertainment_hash
    { "feature" => 0.2, "offer" => 0.5, "virtual_tour" => 0.01 }
  end

  def billiard_hash
    { "feature" => 0.2, "offer" => 0.5, "virtual_tour" => 0.01 }
  end

  def sport_hash
    { "title" => 0.5, "virtual_tour" => 0.01 }
  end

  def culture_hash
    { "feature" => 0.2, "virtual_tour" => 0.01 }
  end

  def car_wash_hash
    { "feature" => 0.5, "offer" => 0.5, "virtual_tour" => 0.01 }
  end

  def salon_center_hash
    { "feature" => 0.5, "offer" => 0.5, "virtual_tour" => 0.01 }
  end

  def creation_hash
    { "title" => 0.5, "virtual_tour" => 0.01 }
  end

  def hotel_hash
    { "feature" => 0.5, "offer" => 0.5, "virtual_tour" => 0.01 }
  end

  def travel_hash
    { "feature" => 0.5, "offer" => 0.5, "virtual_tour" => 0.01 }
  end

  def car_sales_center_hash
    { "feature" => 0.5, "offer" => 0.5, "virtual_tour" => 0.01 }
  end

  def car_service_center_hash
    { "offer" => 0.5, "virtual_tour" => 0.01 }
  end

  def sauna_hash
    { "feature" => 0.5, "offer" => 0.5, "virtual_tour" => 0.01 }
  end

  def sauna_accessory_hash
    { "sheets" => 0.5, "sneakers" => 0.5, "bathrobes" => 0.1, "towels" => 0.2 }
  end

  def sauna_broom_hash
    { "ability" => 0.2, "sale" => 0.1 }
  end

  def sauna_alcohol_hash
    { "ability_own" => 0.2, "sale" => 0.4 }
  end

  def sauna_oil_hash
    { "ability" => 0.2, "sale" => 0.4 }
  end

  def sauna_child_stuff_hash
   { "life_jacket" => 0.5, "cartoons" => 0.1, "games" => 0.1, "rubber_ring" => 0.1 }
  end

  def sauna_stuff_hash
    { "wifi" => 0.2, "safe" => 0.1 }
  end

  def sauna_massage_hash
    { "classical" => 0.5, "spa" => 0.5, "anticelltilitis" => 0.5 }
  end

  def sauna_hall_hash
    { "description" => 0.5, "virtual_tour" => 0.01 }
  end

  def sauna_hall_bath_hash
    { "russian" => 0.5, "finnish" => 0.5, "turkish" => 0.5, "japanese" => 0.5, "infrared" => 0.5 }
  end

  def sauna_hall_capacity_hash
    { "maximal" => 0.4, "extra_guest_cost" => 0.2 }
  end

  def sauna_hall_entertainment_hash
    { "karaoke" => 0.3, "tv" => 0.1, "billiard" => 0.7, "ping_pong" => 0.1, "hookah" => 0.2, "aerohockey" => 0.1, "checkers" => 0.1,
      "backgammon" => 0.1, "guitar" => 0.1 }
  end

  def sauna_hall_interior_hash
    { "floors" => 0.2, "lounges" => 0.2, "pit" => 0.1, "pylon" => 0.2, "barbecue" => 0.1 }
  end

  def sauna_hall_pool_hash
    { "size" => 0.5, "contraflow" => 0.2, "geyser" => 0.2, "waterfall" => 0.2, "water_filter" => 0.2, "jacuzzi" => 0.2, "bucket" => 0.1 }
  end
end
