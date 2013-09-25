class InviteablesSearchController < ApplicationController
  layout false

  def show
    @results = Sunspot.search(Afisha, Organization) {
      with :inviteable_categories, params[:category]
    }.results
  end
end
