class Manage::EntertainmentsController < Manage::ApplicationController
  defaults :singleton => true

  actions :all, :except => :show

  belongs_to :organization, :optional => true

  before_filter :redirect_to_edit, :only => :new, :if => :entertainment_exists?

  def index
    @collection = Entertainment.page(params[:page] || 1).per(10)
  end

  private

  def redirect_to_edit
    redirect_to edit_manage_organization_entertainment_path(parent) and return
  end

  def entertainment_exists?
    parent.entertainment
  end
end
