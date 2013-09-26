class InviteablesSearchController < ApplicationController
  layout false

  def show
    @results = Sunspot.search(Afisha, Organization) {
      with :inviteable_categories, params[:category]
      paginate :page => params[:page] || 1, :per_page => 5
    }.results
  end
end
