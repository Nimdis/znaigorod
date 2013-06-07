class Manage::ExhibitionsController < Manage::ApplicationController
  has_scope :page, :default => 1
  has_scope :by_state, :only => :index

  def index
    @exhibitions = apply_scopes(Exhibition).page(params[:page], :per_page => per_page)
  end
end
