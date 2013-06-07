class Manage::SpectaclesController < Manage::ApplicationController
  has_scope :page, :default => 1
  has_scope :by_state, :only => :index

  def index
    @spectacles = apply_scopes(Spectacle).page(params[:page], :per_page => per_page)
  end
end
