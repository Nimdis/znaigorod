class Manage::TicketInfosController < Manage::ApplicationController
  actions :index, :new, :create

  belongs_to :affiche, optional: true

  has_scope :by_state

  has_scope :page, :default => 1 do |controller, scope, value|
    scope.page(value).per(10)
  end

  def create
    create! { parent_path }
  end
end
