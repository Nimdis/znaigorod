class Manage::TicketsController < Manage::ApplicationController
  actions :new, :create, :destroy
  belongs_to :affiche
end
