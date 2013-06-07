class Manage::MasterClassesController < Manage::ApplicationController
  has_scope :page, :default => 1
  has_scope :by_state, :only => :index

  def index
    @master_classes = apply_scopes(MasterClass).page(params[:page], :per_page => per_page)
  end
end
