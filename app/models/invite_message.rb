# encoding: utf-8

class InviteMessage < Message
  enumerize :invite_kind, in: [:inviter, :invited], predicates: true
  before_create :set_body

private
  def set_body
    #I18n.t("invite_message.#{messageable.class.name.underscore}.#{invite_kind}_message", url: messageable.is_a?(Afisha) ? afisha_show_url(messageable) : organization_url(messageable))
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

