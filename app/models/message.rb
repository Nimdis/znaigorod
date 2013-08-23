# encoding: utf-8

class Message < ActiveRecord::Base
  attr_accessible :account, :account_id, :body, :state, :kind, :producer, :producer_id, :producer_type, :messageable

  belongs_to :account
  belongs_to :producer, class_name: 'Account'
  belongs_to :messageable, :polymorphic => true

  scope :unread, -> { where(state: :new) }

  extend Enumerize
  enumerize :state, in: [:new, :read], default: :new, predicates: true, scope: true

  def change_message_status
    self.new? ? self.state = :read : self.state = :new
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
#

