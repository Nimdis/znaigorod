class Billiard < Entertainment
  include HasVirtualTour

  has_many :pool_tables, :dependent => :destroy

  presents_as_checkboxes :category, :default_value => Values.instance.billiard.categories
  presents_as_checkboxes :feature
  presents_as_checkboxes :offer

  include SmsClaims
end

# == Schema Information
#
# Table name: entertainments
#
#  id              :integer          not null, primary key
#  category        :text
#  feature         :text
#  offer           :text
#  payment         :string(255)
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  title           :string(255)
#  description     :text
#  type            :string(255)
#

