class Manage::BilliardsController < Manage::ApplicationController
  defaults :singleton => true

  actions :all, :except => :show

  belongs_to :organization, :optional => true

  before_filter :redirect_to_edit, :only => :new, :if => :billiard_exists?

  def index
    @collection = Billiard.page(params[:page] || 1).per(10)
  end

  private

  def redirect_to_edit
    redirect_to edit_manage_organization_billiard_path(parent) and return
  end

  def billiard_exists?
    parent.billiard
  end
end
