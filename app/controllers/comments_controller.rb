class CommentsController < ApplicationController
  inherit_resources

  actions :show, :new, :create

  Affiche.descendants.each do |type|
    belongs_to type.name.underscore, :polymorphic => true, :optional => :true
  end

  belongs_to :affiche, :polymorphic => true, :optional => true
  belongs_to :coupon, :polymorphic => true, :optional => true
  belongs_to :organization, :polymorphic => true, :optional => true
  belongs_to :post, :polymorphic => true, :optional => true
  belongs_to :work, :polymorphic => true, :optional => true

  layout false

  private
    alias_method :old_build_resource, :build_resource

    def build_resource
      old_build_resource.tap do |object|
        object.user = current_user
      end
    end
end
