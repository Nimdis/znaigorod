# encoding: utf-8

class PrivateMessage < Message
  attr_accessible :account, :body, :state, :producer

  scope :from, ->(account) { where(producer_id: account) }
  scope :to, ->(account) { where(account_id: account) }
  scope :dialog, ->(from, to) { where("(account_id = #{from.id} and producer_id = #{to.id}) or (account_id = #{to.id} and producer_id = #{from.id})") }
end
