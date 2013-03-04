class CulturesController < ApplicationController
  def index
    @presenter = CulturesPresenter.new(params)

    render partial: 'organizations/organizations_list', layout: false and return if request.xhr?
  end
end
