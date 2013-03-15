class Contact < ActiveRecord::Base
  attr_accessible :email, :facebook, :full_name, :mobile_phone, :phone, :post, :skype, :vkontakte

  belongs_to :organization
end
