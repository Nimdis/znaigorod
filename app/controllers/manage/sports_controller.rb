class Manage::SportsController < Manage::ApplicationController
  defaults :singleton => true

  actions :all, :except => :show

  belongs_to :organization, :optional => true

  before_filter :redirect_to_edit, :only => :new, :if => :sport_exists?

  def index
    @collection = Sport.page(params[:page] || 1).per(10)
  end

  private

  def redirect_to_edit
    redirect_to edit_manage_organization_sport_path(parent) and return
  end

  def sport_exists?
    parent.sport
  end
end
