# encoding: utf-8

class Message < ActiveRecord::Base
  attr_accessible :account, :account_id, :body, :state, :kind, :producer, :producer_id, :producer_type, :messageabl, :messageable_id, :messageable_type, :invite_kind

  belongs_to :account
  belongs_to :producer, class_name: 'Account'
  belongs_to :messageable, :polymorphic => true

  scope :unread, -> { where(state: :unread) }

  extend Enumerize
  enumerize :state, in: [:unread, :read], default: :unread, predicates: true, scope: true

  def change_message_status
    self.unread? ? self.state = :read : self.state = :unread
    self.save
  end

end

# == Schema Information
#
# Table name: messages
#
#  id               :integer          not null, primary key
#  messageable_id   :integer
#  messageable_type :string(255)
#  account_id       :integer
#  producer_id      :integer
#  body             :text
#  state            :string(255)
#  kind             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  type             :string(255)
#  producer_type    :string(255)
#  invite_kind      :string(255)
#

