class InvitationCategoriesSearchController < ApplicationController
  layout false

  def show
    @results = Sunspot.search(Afisha, Organization) {
      with :invitation_categories, params[:invitation_category]
    }.results
  end
end
