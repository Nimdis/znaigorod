class Crm::ContactsController < Crm::ApplicationController
  inherit_resources
  actions :all, :except => [:show, :index]
  belongs_to :organization
end
