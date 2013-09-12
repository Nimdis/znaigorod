class ContestsController < ApplicationController

  def index
    @contests = Contest.ordered_by_starts_on
  end

  def show
    @contest = Contest.find(params[:id])
    @works = @contest.works.ordered.page(params[:page]).per(12)

    render :partial => 'works/list' and return if request.xhr?
  end
end
