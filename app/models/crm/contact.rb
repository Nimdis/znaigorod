# encoding: utf-8

class Contact < ActiveRecord::Base
  attr_accessible :email, :facebook, :full_name, :mobile_phone, :phone, :post, :skype, :vkontakte
  validates_presence_of :full_name, :post

  belongs_to :organization

  def to_s
    "#{full_name}, #{post}"
  end
end

# == Schema Information
#
# Table name: contacts
#
#  id              :integer          not null, primary key
#  full_name       :string(255)
#  post            :string(255)
#  phone           :string(255)
#  mobile_phone    :string(255)
#  email           :string(255)
#  skype           :string(255)
#  vkontakte       :string(255)
#  facebook        :string(255)
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

