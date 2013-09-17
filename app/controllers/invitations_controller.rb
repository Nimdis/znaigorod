class InvitationsController < ApplicationController
  inherit_resources

  load_and_authorize_resource

  actions :new, :create, :destroy, :show

  belongs_to :afisha, :optional => true
  belongs_to :organization, :optional => true

  layout false

  def new
    new! {
      @accounts = Account.search { paginate :page => 1, :per_page => 10 }.results
    }
  end

  def create
    create! {
      render :partial => 'invitation', :locals => { :inviteable => parent, :kind => @invitation.kind } and return
    }
  end

  def show
    show! {
      @accounts = Account.search { paginate :page => 1, :per_page => 10 }.results

      render :new and return
    }
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
