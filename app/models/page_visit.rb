class PageVisit < ActiveRecord::Base
  attr_accessible :session, :user

  belongs_to :page_visitable, :polymorphic => true
  belongs_to :user

  after_save :update_account_rating, :update_page_visitable_rating


  private
    def update_account_rating
      user.account.update_rating if user
    end

    def update_page_visitable_rating
      #page_visitable.update_rating
    end
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

