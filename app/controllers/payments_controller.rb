class PaymentsController < ApplicationController
  inherit_resources
  actions :index
  belongs_to :user, :optional => true
end
