class Manage::OthersController < Manage::ApplicationController
  has_scope :page, :default => 1
  has_scope :by_state, :only => :index

  def index
    @others = apply_scopes(Other).page(params[:page], :per_page => per_page)
  end
end
