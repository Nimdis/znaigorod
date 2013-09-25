class CooperationController < ApplicationController

  def benefit
  end

  def statistics
  end

  def services
    @service_payment = ServicePayment.new
  end

  def our_customers
    @presenter = OrganizationsCatalogPresenter.new(params.merge(:only_clients => true))

    render partial: 'organizations/organizations_posters', layout: false and return if request.xhr?
  end

end
