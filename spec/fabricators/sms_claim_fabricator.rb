Fabricator :sms_claim do
  phone '+7-(999)-999-9999'
  name 'Real man'
  details 'I wanna rock'
  claimed { Fabricate :sauna }
end

# == Schema Information
#
# Table name: sms_claims
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  phone        :string(255)
#  details      :text
#  claimed_id   :integer
#  claimed_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

