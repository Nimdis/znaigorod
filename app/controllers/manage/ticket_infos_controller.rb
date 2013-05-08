class Manage::TicketInfosController < Manage::ApplicationController
  actions :index, :new, :create

  belongs_to :affiche, optional: true

  def create
    create! { parent_path }
  end
end
