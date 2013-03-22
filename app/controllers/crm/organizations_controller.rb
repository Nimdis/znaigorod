class Crm::OrganizationsController < Crm::ApplicationController

  actions :index, :show, :edit, :update

  has_scope :page, default: 1

  def index
    @organizations = HasSearcher.searcher(:manage_organization, params[:search]).
      paginate(page: params[:page] || 1, per_page: 10).results
  end

  def update
    update! { render partial: 'manager' and return }
  end

end
