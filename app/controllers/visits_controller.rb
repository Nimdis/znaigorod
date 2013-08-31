class VisitsController < ApplicationController
  inherit_resources
  load_and_authorize_resource

  actions :all

  custom_actions :collection => [:destroy_visits, :visitors]

  belongs_to :afisha, :organization, :post, :polymorphic => true, :optional => true
  belongs_to :account, :optional => true

  layout false unless :index

  def index
    index! {
      render partial: 'accounts/visits', locals: { visits: @visits }, layout: false and return if @account
    }
  end

  def new
    new! {
      @users = User.ordered.page(params[:page]).per(10)
      @visit.user_id = current_user.id
      if params[:acts_as_invited]
        @acts_as = 'invited'
        render partial: 'invites/invited' and return
      elsif params[:acts_as_inviter]
        @acts_as = 'inviter'
        render partial: 'invites/inviter' and return
      end
    }
  end

  def create
    create! {
      if request.xhr?
        render :partial => 'visit', :locals => { :visitable => parent } and return
      else
        redirect_to (parent.is_a?(Afisha) ? afisha_show_path(parent) : polymorphic_url(parent)) and return
      end
    }
  end

  def edit
    edit! {
      @users = User.ordered.page(params[:page]).per(5)
      if params[:acts_as_invited]
        @acts_as = 'invited'
        render partial: 'invites/invited' and return
      elsif params[:acts_as_inviter]
        @acts_as = 'inviter'
        render partial: 'invites/inviter' and return
      end
    }
  end

  def update
    update! {
      redirect_to (parent.is_a?(Afisha) ? afisha_show_path(parent) : polymorphic_url(parent)) and return
    }
  end

  def destroy_visits
    destroy_visits!{
      @visits = current_user.visits.where(visitable_id: parent.id)
      @visits.destroy_all

      render :partial => 'visit', :locals => { :visitable => parent.reload } and return
    }
  end

  def visitors
    visitors!{
      @users = parent.visits.map(&:user)
      render :partial => 'visitors', :locals => { :visitable => parent } and return
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
  end
end
