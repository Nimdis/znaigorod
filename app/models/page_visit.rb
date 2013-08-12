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
