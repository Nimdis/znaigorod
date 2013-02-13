class Manage::SaunasController < Manage::ApplicationController
  defaults :singleton => true

  actions :all, :except => :show

  belongs_to :organization, :optional => true

  before_filter :redirect_to_edit, :only => :new, :if => :sauna_exists?

  def index
    @collection = Sauna.page(params[:page] || 1).per(10)
  end

  private

  def redirect_to_edit
    redirect_to edit_manage_organization_sauna_path(parent) and return
  end

  def sauna_exists?
    parent.sauna
  end
end
