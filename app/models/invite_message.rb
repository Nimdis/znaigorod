# encoding: utf-8

class InviteMessage < Message
  attr_accessible :agreement, :messageable_id, :messageable_type, :invite_kind, :state, :kind
  enumerize :invite_kind, in: [:inviter, :invited], predicates: true
  enumerize :agreement, :in => [:agree, :disagree], :predicates => true
  before_update :process_message, :if => ->(m) { m.changes.keys.include?('agreement') }

  has_many :notification_messages, :as => :messageable, :dependent => :destroy

  delegate :account, :invited, :to => :messageable

  def relation_at(account_obj)
    if account_obj.id == invited.id
      'inbox'
    elsif account_obj.id == account.id
      'sended'
    else
      'undefined'
    end
  end

  def opponent_of(account_obj)
    if relation_at(account_obj) == 'inbox'
      account
    elsif relation_at(account_obj) == 'sended'
      invited
    end
  end

private
  def process_message
    self.state = :read
    notification_messages.create :producer => invited, :account => account, :kind => "#{self.agreement}d_invite"
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
#  agreement        :string(255)
#


