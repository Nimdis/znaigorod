# encoding: utf-8

class Message < ActiveRecord::Base
  attr_accessible :account, :body, :state, :kind, :producer_id

  belongs_to :account
  belongs_to :messageable, :polymorphic => true

  extend Enumerize
  enumerize :state, in: [:new, :read], default: :new, predicates: true
  enumerize :kind, in: [:new_comment, :reply_on_comment, :afisha_published, :afisha_returned, :user_vote_afisha, :user_vote_comment, :user_visit_afisha, :user_add_friend]

  def producer
    Account.find(producer_id)
  end
end
