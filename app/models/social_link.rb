class SocialLink < ActiveRecord::Base
  attr_accessible :title, :url

  belongs_to :organization
end

# == Schema Information
#
# Table name: social_links
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  title           :text
#  url             :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

