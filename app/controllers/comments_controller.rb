class CommentsController < ApplicationController
  inherit_resources

  actions :show, :new, :create

  belongs_to :afisha, :polymorphic => true, :optional => true
  belongs_to :coupon, :polymorphic => true, :optional => true
  belongs_to :organization, :polymorphic => true, :optional => true
  belongs_to :post, :polymorphic => true, :optional => true
  belongs_to :work, :polymorphic => true, :optional => true
  belongs_to :account, :optional => true

  layout false

  private
    alias_method :old_build_resource, :build_resource

    def build_resource
      old_build_resource.tap do |object|
        object.user = current_user
      end
    end
end
