class WorksController < ApplicationController
  inherit_resources
  actions :show
  belongs_to :contest
end
