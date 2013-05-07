class Manage::TicketInfosController < Manage::ApplicationController
  actions :new, :create, :destroy

  belongs_to :affiche
end
