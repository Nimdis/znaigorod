class Manage::CommentsController < Manage::ApplicationController
  has_scope :page, :default => 1
  actions :index, :destroy

  def collection
    super.page(params[:page])
  end
end
