class EventsController < ApplicationController
  inherit_resources
  actions :index
  belongs_to :account, :optional => true
end