class Activity < ActiveRecord::Base
  attr_accessible :title, :state, :activity_at, :user_id, :contact_id, :status

  belongs_to :organization
  belongs_to :user

  searcheble do
    string   :state
    string   :status
    integer  :user_id
    date     :activity_at
  end

  extend Enumerize
  enumerize :status, :in => [:fresh, :talks, :waiting_for_payment, :client, :non_cooperation]

  default_value_for :status, :fresh

  enumerize :state, :in => [:planned, :completed]

  default_value_for :status, :planned

end
