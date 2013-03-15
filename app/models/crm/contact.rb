class Contact < ActiveRecord::Base
  attr_accessible :email, :facebook, :full_name, :mobile_phone, :phone, :post, :skype, :vkontakte
  validates_presence_of :full_name, :post

  belongs_to :organization

  def to_s
    "#{full_name}, #{post}"
  end
end
