class PageVisit < ActiveRecord::Base
  attr_accessible :session

  belongs_to :page_visitable, :polymorphic => true
end
