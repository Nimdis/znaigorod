class Manage::CulturesController < Manage::ApplicationController
  defaults :singleton => true

  actions :all, :except => :show

  belongs_to :organization, :optional => true

  before_filter :redirect_to_edit, :only => :new, :if => :culture_exists?

  def index
    @collection = Culture.page(params[:page] || 1).per(10)
  end

  private

  def redirect_to_edit
    redirect_to edit_manage_organization_culture_path(parent) and return
  end

  def culture_exists?
    parent.culture
  end
end
