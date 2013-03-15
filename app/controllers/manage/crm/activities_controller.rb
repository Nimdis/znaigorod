class Manage::Crm::ActivitiesController < Manage::Crm::ApplicationController
  def index
    @activities = Activity.all
  end
end
