class CommentsController < ApplicationController
  inherit_resources

  actions :index, :show, :new, :create

  belongs_to :afisha, :polymorphic => true, :optional => true
  belongs_to :coupon, :polymorphic => true, :optional => true
  belongs_to :organization, :polymorphic => true, :optional => true
  belongs_to :post, :polymorphic => true, :optional => true
  belongs_to :work, :polymorphic => true, :optional => true
  belongs_to :account, :optional => true

  layout false

  def index
    index! {
      @comments = end_of_association_chain.rendereable.page(params[:page]).per(3)
      render partial: 'accounts/comments', locals: { comments: @comments }, layout: false and return if @account
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
