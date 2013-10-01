class InvitationsStuff < ActiveRecord::Migration
  def up
    Invitation.skip_callback :create, :after, :create_invite_message

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

    Visit.where('acts_as_inviter IS NOT NULL').each do |visit|
      invitation = Invitation.new do |invitation|
        invitation.account    = visit.user.account
        invitation.inviteable = visit.visitable
        invitation.gender     = visit.inviter_gender
        invitation.kind       = :inviter
      end

      invitation.save!
    end

    Visit.where('acts_as_invited IS NOT NULL').each do |visit|
      invitation = Invitation.new do |invitation|
        invitation.account    = visit.user.account
        invitation.inviteable = visit.visitable
        invitation.gender     = visit.invited_gender
        invitation.kind       = :invited
      end

      invitation.save!
    end
  end

  def down
  end
end
