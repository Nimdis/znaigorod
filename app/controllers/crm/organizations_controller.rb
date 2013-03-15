class Crm::OrganizationsController < Crm::ApplicationController
  def index
    @organizations = Organization.limit(20)
  end

  def show
    @organization = Organization.find(params[:id])
  end
end
