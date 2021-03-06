class VisitsController < ApplicationController
  inherit_resources

  load_and_authorize_resource

  actions :index, :create, :show, :destroy

  belongs_to :afisha, :optional => true
  belongs_to :organization, :optional => true
  belongs_to :account, :optional => true

  has_scope :page, :default => 1

  layout false

  def index
    index! {
      render partial: 'commons/social_block_visits', locals: { visits: @visits }, layout: false and return if @afisha || @organization

      @account ||= current_user.account
      render partial: 'accounts/visits', locals: { visits: @visits }, layout: false and return
    }
  end

  def create
    create! {
      @visits = parent.visits.page(1)
      render :partial => 'commons/social_block', :locals => { :inviteable => parent } and return
    }
  end

  def destroy
    destroy! {
      @visits = parent.visits.page(1)
      render :partial => 'commons/social_block', :locals => { :inviteable => parent } and return
    }
  end

  protected

  def build_resource
    super.user = current_user

    @visit
  end
end
