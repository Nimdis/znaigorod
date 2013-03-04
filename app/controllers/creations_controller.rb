class CreationsController < ApplicationController
  def index
    @presenter = CreationsPresenter.new(params)

    render partial: 'organizations/organizations_list', layout: false and return if request.xhr?
  end
end
