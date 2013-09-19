class InvitationsController < ApplicationController
  inherit_resources

  load_and_authorize_resource

  actions :all

  belongs_to :afisha, :optional => true
  belongs_to :organization, :optional => true

  layout false

  def new
    new! {
      @accounts = Account.search { paginate :page => params[:page], :per_page => 10 }.results
    }
  end

  def create
    create! {
      render :partial => 'commons/social_block', :locals => { :inviteable => parent } and return
    }
  end

  def show
    show! {
      @accounts = Account.search { paginate :page => params[:page], :per_page => 10 }.results

      render :partial => 'commons/social_block', :locals => { :inviteable => parent } and return
    }
  end

  def edit
    edit! {
      @accounts = Account.search { paginate :page => params[:page], :per_page => 10 }.results
    }
  end

  def update
    update! {
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
    super.account = current_user.account

    @invitation
  end
end
