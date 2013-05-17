class Manage::TicketInfosController < Manage::ApplicationController
  actions :index, :new, :create

  belongs_to :affiche, optional: true

  has_scope :by_state

  def create
    create! { parent_path }
  end
end
