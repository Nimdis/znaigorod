Fabricator :payment do
  number 2
  phone '+7-(999)-999-9999'
  ticket
end

# == Schema Information
#
# Table name: payments
#
#  id         :integer          not null, primary key
#  ticket_id  :integer
#  number     :integer
#  phone      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

