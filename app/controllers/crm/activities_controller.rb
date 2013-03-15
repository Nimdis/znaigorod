class Crm::ActivitiesController < Crm::ApplicationController
  inherit_resources
  actions :all, :except => [:show, :index]
  belongs_to :organization
end
