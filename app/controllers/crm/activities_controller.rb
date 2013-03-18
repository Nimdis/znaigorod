class Crm::ActivitiesController < Crm::ApplicationController
  actions :all, except: :show

  belongs_to :organization, optional: true

  has_scope :page, default: 1

  def index
    @activities = HasSearcher.searcher(:activities, params[:search]).
      paginate(page: params[:page], per_page: 10).results
  end

  def create
    create! { parent_path }
  end

  def update
    update! { parent_path }
  end

  def destroy
    destroy! { parent_path }
  end
end
