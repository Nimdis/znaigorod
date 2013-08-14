Fabricator :organization do
  title 'Some cool organization'
  priority_suborganization_kind 'meal'
  phone_for_sms '+7-(999)-999-9999'
end

# == Schema Information
#
# Table name: organizations
#
#  id                            :integer          not null, primary key
#  title                         :text
#  site                          :text
#  email                         :text
#  description                   :text
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  phone                         :text
#  vfs_path                      :string(255)
#  organization_id               :integer
#  logotype_url                  :text
#  slug                          :string(255)
#  rating                        :float
#  non_cash                      :boolean
#  priority_suborganization_kind :string(255)
#  comment                       :text
#  additional_rating             :integer
#  yandex_metrika_page_views     :integer
#  vkontakte_likes               :integer
#  subdomain                     :string(255)
#  user_id                       :integer
#  status                        :string(255)
#  total_rating                  :float
#  primary_organization_id       :integer
#  ability_to_comment            :boolean          default(TRUE)
#  phone_for_sms                 :string(255)
#  balance                       :float
#  fb_likes                      :integer
#  odn_likes                     :integer
#

