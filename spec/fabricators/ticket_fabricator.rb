Fabricator :ticket do
  ticket_info
  payment
end

# == Schema Information
#
# Table name: tickets
#
#  id             :integer          not null, primary key
#  ticket_info_id :integer
#  state          :string(255)
#  code           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  payment_id     :integer
#

