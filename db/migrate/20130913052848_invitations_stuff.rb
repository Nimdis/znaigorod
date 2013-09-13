class InvitationsStuff < ActiveRecord::Migration
  def up
    Invitation.skip_callback :create, :after

    InviteMessage.all.each do |invite_message|
      invitation = Invitation.new do |invitation|
        invitation.inviteable = invite_message.messageable
        invitation.account_id = invite_message.producer_id
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
