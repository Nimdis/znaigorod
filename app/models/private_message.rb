# encoding: utf-8

class PrivateMessage < Message
  attr_accessible :account, :body, :state, :producer

  scope :from, ->(account) { where(producer_id: account) }
  scope :to, ->(account) { where(account_id: account) }
  scope :dialog, ->(from, to) { where("(account_id = #{from} and producer_id = #{to}) or (account_id = #{to} and producer_id = #{from})") }

  validates_presence_of :body
end
