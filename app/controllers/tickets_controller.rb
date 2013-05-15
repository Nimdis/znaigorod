class TicketsController < ApplicationController
  has_scope :page, default: 1

  def index
    @ticket_infos = TicketInfo.page(params[:page]).per(12)
  end
end
