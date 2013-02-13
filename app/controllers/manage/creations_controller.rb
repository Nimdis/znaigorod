class Manage::CreationsController < Manage::ApplicationController
  defaults :singleton => true

  actions :all, :except => :show

  belongs_to :organization, :optional => true

  before_filter :redirect_to_edit, :only => :new, :if => :creation_exists?

  def index
    @collection = Creation.page(params[:page] || 1).per(10)
  end

  private

  def redirect_to_edit
    redirect_to edit_manage_organization_creation_path(parent) and return
  end

  def creation_exists?
    parent.creation
  end
end
