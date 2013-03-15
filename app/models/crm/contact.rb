class Contact < ActiveRecord::Base
  attr_accessible :email, :facebook, :full_name, :mobile_phone, :phone, :post, :skype, :vkontakte
  validates_presence_of :full_name

  belongs_to :organization
end
