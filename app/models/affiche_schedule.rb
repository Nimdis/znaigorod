# encoding: utf-8

class AfficheSchedule < ActiveRecord::Base
  attr_accessible :affiche, :ends_at, :ends_on, :hall, :holidays, :place,
                  :price_max, :price_min, :starts_at, :starts_on,
                  :organization_id, :longitude, :latitude

  belongs_to :affiche

  validates_presence_of :ends_at, :ends_on, :place, :starts_at, :starts_on

  after_save :destroy_showings
  after_save :create_showings
  after_destroy :destroy_showings

  default_value_for :price_min, 0
  default_value_for :price_max, 0

  serialize :holidays, Array

  normalize_attribute :holidays, :with => [:as_array_of_integer]

  def get_latitude
    affiche.try(:showings).try(:first).try(:latitude)
  end

  def get_longitude
    affiche.try(:showings).try(:first).try(:longitude)
  end

  def get_organization_id
    affiche.try(:showings).try(:first).try(:organization_id)
  end

  private
    def create_showings
      (starts_on..ends_on).each do |date|
        wday = date.wday == 0 ? 7 : date.wday
        affiche.create_showing attributes_for_showing_on(date) unless holidays.include? wday
      end
    end

    def concat_date_and_time(date, time)
      Time.zone.parse "#{date.to_s} #{I18n.l(time, :format => '%H:%M')}"
    end

    def destroy_showings
      affiche.destroy_showings
    end

    def attributes_for_showing_on(date)
      attributes.reject { |k| k.match /(id|created_at|updated_at|starts_on|ends_on)/ }.tap do |hash|
        hash['starts_at'] = concat_date_and_time(date, hash['starts_at'])
        hash['ends_at'] = concat_date_and_time(date, hash['ends_at'])
        hash['latitude'] = latitude
        hash['longitude'] = longitude
        hash['organization_id'] = organization_id
      end
    end
end

# == Schema Information
#
# Table name: affiche_schedules
#
#  id              :integer          not null, primary key
#  affiche_id      :integer
#  starts_on       :date
#  ends_on         :date
#  starts_at       :time
#  ends_at         :time
#  holidays        :string(255)
#  place           :string(255)
#  hall            :string(255)
#  price_min       :integer
#  price_max       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#  latitude        :string(255)
#  longitude       :string(255)
#

