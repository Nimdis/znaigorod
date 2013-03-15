class Activity < ActiveRecord::Base
  attr_accessible :title

  belongs_to :organization
  belongs_to :user


  # <=== CRM

  extend Enumerize
  enumerize :status, :in => [:fresh, :talks, :waiting_for_payment, :client, :non_cooperation]

  default_value_for :status, :fresh

  # CRM ===>
end
