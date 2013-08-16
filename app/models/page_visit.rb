class PageVisit < ActiveRecord::Base
  attr_accessible :session, :user

  belongs_to :page_visitable, :polymorphic => true
  belongs_to :user

end

# == Schema Information
#
# Table name: page_visits
#
#  id                  :integer          not null, primary key
#  session             :text
#  page_visitable_id   :integer
#  page_visitable_type :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :integer
#

