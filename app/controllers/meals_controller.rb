class MealsController < ApplicationController
  def index
    @presenter = MealsPresenter.new(params)

    render partial: 'organizations/organizations_list', layout: false and return if request.xhr?
  end
end
