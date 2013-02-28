class EntertainmentsController < ApplicationController
  def index
    @entertainments_presenter = EntertainmentsPresenter.new(params)

    if request.xhr?
      render :nothing
    end
  end
end
