class InvitationsController < ApplicationController
  inherit_resources

  load_and_authorize_resource

  actions :all

  belongs_to :afisha, :optional => true
  belongs_to :organization, :optional => true

  layout false

  def create
    create! do
      case params[:render]
      when 'nothing'
        render :nothing => true
      when 'show'
        render :show
      when 'social'
        render :partial => 'commons/social_block', :locals => { :inviteable => parent }
      end

      return
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
