class SportsController < ApplicationController
  def index
    @presenter = SportsPresenter.new(params)

    render partial: 'organizations/organizations_list', layout: false and return if request.xhr?
  end
end
