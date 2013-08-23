class VisitsController < ApplicationController
  inherit_resources

  actions :all, except: :index 

  custom_actions :collection => [:change_visit, :visitors]

  belongs_to :afisha, :organization, :polymorphic => true, :optional => true
  belongs_to :account, :optional => true

  layout false unless :index

  def new
    @afisha = Afisha.find(params[:afisha_id])
    @visit = @afisha.visits.new(user_id: current_user.id, description: params[:description], gender: params[:gender], acts_as: params[:acts_as])
    render partial: 'visits/form'
  end

  def edit
    @afisha = Afisha.find(params[:afisha_id])
    @visit = Visit.find(params[:id])
    render partial: 'visits/form'
  end

  def update
    update! { 
      redirect_to (parent.is_a?(Afisha) ? afisha_show_path(parent) : polymorphic_url(parent)) and return
    }
  end

  def create
    create! {
      redirect_to (parent.is_a?(Afisha) ? afisha_show_path(parent) : polymorphic_url(parent)) and return
    }
  end

  def change_visit
    change_visit!{
      if current_user
        @visit = current_user.visit_for(parent).first || parent.visits.new(:user_id => current_user.id)
      else
        @visit = parent.visits.new
      end

      @visit.change_visit
      render :partial => 'visit', :locals => { :visitable => parent } and return
    }
  end

  def visitors
    visitors!{
      @users = parent.visits.visited.map(&:user)
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
end
