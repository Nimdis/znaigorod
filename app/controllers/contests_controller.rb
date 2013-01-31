class ContestsController < ApplicationController
  def show
    @contest = Contest.find(params[:id])
    @works = @contest.works.ordered.page(params[:page]).per(9)
    render :partial => 'works/list' and return if request.xhr?
  end
end
