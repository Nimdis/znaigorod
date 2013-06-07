class Manage::MoviesController < Manage::ApplicationController
  has_scope :page, :default => 1
  has_scope :by_state, :only => :index

  def index
    @movies = apply_scopes(Movie).page(params[:page], :per_page => per_page)
  end
end
