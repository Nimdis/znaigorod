class InvitationsStuff < ActiveRecord::Migration
  def up
    InviteMessage.all.each do |invite_message|
      invitation = Invitation.new do |invitation|
        invitation.account    = invite_message.producer
        invitation.inviteable = invite_message.messageable
        invitation.invited_id = invite_message.account_id
        invitation.kind       = invite_message.invite_kind
      end
      invitation.save!

      invite_message.messageable = invitation
      invite_message.save!
    end
  end

  def down
  end
end
