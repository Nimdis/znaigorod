class Crm::OrganizationsController < Crm::ApplicationController
  actions :index, :show, :edit, :update

  has_scope :page, default: 1

  def index
    params.select! { |key, _| %w[q status user_id suborganizations page].include?(key) }

    @organizations ||= HasSearcher.searcher(:manage_organization, params).
      paginate(page: params[:page] || 1, per_page: 10).results
  end
end
