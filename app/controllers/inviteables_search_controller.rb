class InviteablesSearchController < ApplicationController
  layout false

  def show
    @results = Sunspot.search(Afisha, Organization) {
      keywords params[:q]
      with :inviteable_categories, params[:category]
      paginate :page => params[:page] || 1, :per_page => 5
    }.results

    render :partial => 'results' and return if params[:only_results]
  end
end
