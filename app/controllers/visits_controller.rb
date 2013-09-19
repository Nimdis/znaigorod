class VisitsController < ApplicationController
  inherit_resources

  load_and_authorize_resource

  actions :create, :show, :destroy

  belongs_to :afisha, :optional => true
  belongs_to :organization, :optional => true

  layout false

  def create
    create! {
      render :partial => 'commons/social_block', :locals => { :inviteable => parent } and return
    }
  end

  def destroy
    destroy! {
      render :partial => 'commons/social_block', :locals => { :inviteable => parent } and return
    }
  end

  protected

  def build_resource
    super.user = current_user

    @visit
  end
end
