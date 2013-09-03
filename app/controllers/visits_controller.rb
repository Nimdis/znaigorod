class VisitsController < ApplicationController
  inherit_resources
  load_and_authorize_resource

  actions :all

  custom_actions :collection => :destroy_visits

  belongs_to :afisha, :organization, :post, :polymorphic => true, :optional => true
  belongs_to :account, :optional => true

  layout false unless :index

  def index
    index! {
      render partial: 'accounts/visits', locals: { visits: @visits }, layout: false and return if @account
      render partial: 'afishas/visits', locals: { visits: @visits }, layout: false and return if @afisha
      render partial: 'organizations/visits', locals: { visits: @visits }, layout: false and return if @organization
    }
  end

  def new
    new! {
      @accounts = Account.where('id != ?', current_user.account.id).ordered.page(params[:page]).per(10)
      @visit.user_id = current_user.id
      render partial: 'accounts/list' and return if params[:page].present?
      render partial: 'invites/invite' and return
    }
  end

  def create
    create! {
      if request.xhr?
        @visits = collection
        render :partial => 'visit', :locals => { :visitable => parent } and return
      else
        redirect_to (parent.is_a?(Afisha) ? afisha_show_path(parent) : polymorphic_url(parent)) and return
      end
    }
  end

  def edit
    edit! {
      @accounts = Account.where('id != ?', current_user.account.id).ordered.page(params[:page]).per(10)
      render partial: 'accounts/list' and return if params[:page].present?
      render partial: 'invites/invite' and return
    }
  end

  def update
    update! {
      if request.xhr?
        @visits = collection
        render :partial => 'visit', :locals => { :visitable => parent } and return
      else
        redirect_to (parent.is_a?(Afisha) ? afisha_show_path(parent) : polymorphic_url(parent))
      end
    }
  end

  def destroy_visits
    destroy_visits!{
      @visit = parent.visit_for_user(current_user)
      @visit.destroy
      @visits = collection
      render :partial => 'visit', :locals => { :visitable => parent.reload } and return
    }
  end

  private
  alias_method :old_build_resource, :build_resource

  def build_resource
    old_build_resource.tap do |object|
      object.user = current_user
    end
  end

  def collection
    @visits ||= end_of_association_chain.rendereable.page(params[:page]).per(3) if association_chain.first.is_a?(Account)
    @visits ||= end_of_association_chain.page(params[:page]).per(5) if association_chain.first.is_a?(Afisha) || association_chain.first.is_a?(Organization)
  end
end
