class InvitationsController < ApplicationController
  inherit_resources

  load_and_authorize_resource

  actions :new, :create, :show, :destroy

  belongs_to :afisha, :optional => true
  belongs_to :organization, :optional => true

  layout false

  def create
    create! do
      render :partial => 'commons/social_block', :locals => { :inviteable => parent } and return if @invitation.inviteable
      render :nothing => true and return if @invitation.invited
    end
  end

  def destroy
    destroy! { render :nothing => true and return }
  end

  protected

  def build_resource
    super.account = current_user.account

    @invitation
  end
end
