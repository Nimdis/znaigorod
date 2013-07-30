# encoding: utf-8

class Message < ActiveRecord::Base
  attr_accessible :account, :body, :state

  belongs_to :account
  belongs_to :messageable, :polymorphic => true

  extend Enumerize
  enumerize :state, in: [:new, :read], default: :new, predicates: true
end
