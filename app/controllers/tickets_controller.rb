class TicketsController < ApplicationController
  has_scope :page, default: 1

  def index
    @ticket_infos = TicketInfo.available.page(params[:page]).per(12)
    render partial: 'tickets_list', layout: false and return if request.xhr?
  end
end
