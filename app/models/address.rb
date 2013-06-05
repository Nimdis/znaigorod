# encoding: utf-8

class Address < ActiveRecord::Base
  attr_accessible :house, :latitude, :longitude, :street, :office

  belongs_to :organization

  validates_presence_of :street, :house

  def to_s
    return "" if street.blank? && house.blank?
    return "#{street.squish}" if house.blank?
    return "#{street.squish}, #{house.squish}"
  end

end

# == Schema Information
#
# Table name: addresses
#
#  id              :integer          not null, primary key
#  street          :string(255)
#  house           :string(255)
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  latitude        :string(255)
#  longitude       :string(255)
#  office          :string(255)
#

