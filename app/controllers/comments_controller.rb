class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_action!, :except => :show

  inherit_resources

  actions :show, :new, :create

  belongs_to :post, :polymorphic => true

  layout false

  private
    def authorize_action!
      can? :create, build_resource
    end

    alias_method :old_build_resource, :build_resource

    def build_resource
      old_build_resource.tap do |object|
        object.user = current_user
      end
    end
end
