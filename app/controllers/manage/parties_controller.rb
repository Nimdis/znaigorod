class Manage::PartiesController < Manage::ApplicationController
  has_scope :page, :default => 1
  has_scope :by_state, :only => :index

  def index
    @parties = apply_scopes(Party).page(params[:page], :per_page => per_page)
  end
end
