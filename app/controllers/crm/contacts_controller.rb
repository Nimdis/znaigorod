class Crm::ContactsController < Crm::ApplicationController
  actions :all, :except => [:show, :index]
  belongs_to :organization
end
