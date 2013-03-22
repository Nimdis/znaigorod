class Crm::ActivitiesController < Crm::ApplicationController

  actions :all, except: :show

  belongs_to :organization, optional: true

  has_scope :page, default: 1

  def index
    @activities = HasSearcher.searcher(:activities, params[:search]).
      paginate(page: params[:page], per_page: 10).results
  end

  def create
    create! do |success, failure|
      success.html { render file: 'crm/activities/list' and return }
    end
  end

  def update
    update! do |success, failure|
      success.html { render file: 'crm/activities/list' and return }
    end
  end

  def destroy
    destroy! { parent_path }
  end

end
