class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, :polymorphic => true
  attr_accessible :ancestry, :body, :parent_id
  has_ancestry

  normalize_attribute :body, :ancestry
  validates_presence_of :body

  delegate :name, :avatar, :profile, :to => :user, :prefix => true
end
