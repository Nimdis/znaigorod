Fabricator(:affiche_schedule) do
  starts_on '2012-06-01'
  ends_on '2012-06-05'
  starts_at '11:00'
  ends_at '17:00'
  place 'place'
  hall 'hall'
  price_min 100
  holidays [7]
end

# == Schema Information
#
# Table name: affiche_schedules
#
#  id              :integer          not null, primary key
#  afisha_id       :integer
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

