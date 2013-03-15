class Crm::OrganizationsController < Crm::ApplicationController
  def index
    params.select! { |key, _| %w[q status user_id suborganizations page].include?(key) }

    @organizations ||= HasSearcher.searcher(:manage_organization, params).
      paginate(page: params[:page] || 1, per_page: 10).results
  end

  def show
    @organization = Organization.find(params[:id])
  end
end
