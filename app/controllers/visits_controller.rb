class VisitsController < ApplicationController
  inherit_resources

  custom_actions :collection => :change_visit

  Affiche.descendants.each do |type|
    belongs_to type.name.underscore, :polymorphic => true, :optional => :true
  end

  belongs_to :organization, :polymorphic => true, :optional => true

  layout false

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

  private
    alias_method :old_build_resource, :build_resource

    def build_resource
      old_build_resource.tap do |object|
        object.user = current_user
      end
    end
end
