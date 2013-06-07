class Manage::SportsEventsController < Manage::ApplicationController
  has_scope :page, :default => 1
  has_scope :by_state, :only => :index

  def index
    @sports_events = apply_scopes(SportsEvent).page(params[:page], :per_page => per_page)
  end
end
