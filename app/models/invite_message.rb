# encoding: utf-8
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


class InviteMessage < Message
  attr_accessible :agreement
  enumerize :invite_kind, in: [:inviter, :invited], predicates: true
  before_create :set_body

  def relation_at(account_obj)
    if account_obj.id == account_id
      'inbox'
    elsif account_obj.id == producer_id
      'sended'
    else
      'undefined'
    end
  end

  def opponent_of(account_obj)
    if relation_at(account_obj) == 'inbox'
      producer
    elsif relation_at(account_obj) == 'sended'
      account
    end
  end

private
  def set_body
    #I18n.t("invite_message.#{messageable.class.name.underscore}.#{invite_kind}_message", url: messageable.is_a?(Afisha) ? afisha_show_url(messageable) : organization_url(messageable))
  end
end
