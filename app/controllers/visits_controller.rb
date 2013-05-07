class VisitsController < ApplicationController
  inherit_resources

  actions :new, :create, :show, :update
  belongs_to :organization, :polymorphic => true, :optional => true

  layout false

  private
    alias_method :old_build_resource, :build_resource

    def build_resource
      old_build_resource.tap do |object|
        object.user = current_user
      end
    end
end
