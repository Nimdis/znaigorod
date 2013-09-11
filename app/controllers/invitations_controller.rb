class InvitationsController < ApplicationController
  inherit_resources

  load_and_authorize_resource

  actions :new, :create, :destroy

  belongs_to :afisha, :optional => true
  belongs_to :organization, :optional => true

  layout false

  def create
    create! { render :partial => 'invitation', :locals => { :inviteable => parent, :kind => @invitation.kind } and return }
  end

  def destroy
    destroy! { render :partial => 'invitation', :locals => { :inviteable => parent, :kind => @invitation.kind } and return }
  end

  protected

  def build_resource
    super.account = current_user.account

    @invitation
  end
end
