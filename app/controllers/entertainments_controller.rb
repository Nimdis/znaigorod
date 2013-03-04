class EntertainmentsController < ApplicationController
  def index
    @entertainments_presenter = OrganizationsPresenter.new(params.merge(kind: 'entertainment'))

    render partial: 'organizations/organizations_list', layout: false and return if request.xhr?
  end
end
