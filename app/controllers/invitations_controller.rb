class InvitationsController < ApplicationController
  inherit_resources

  load_and_authorize_resource

  actions :new, :create, :destroy

  belongs_to :afisha, :optional => true
  belongs_to :organization, :optional => true

  layout false

  protected

  def build_resource
    super.account = current_user.account

    @invitation
  end
end
