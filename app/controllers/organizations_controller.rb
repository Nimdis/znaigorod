# encoding: utf-8

class OrganizationsController < ApplicationController
  has_scope :page, :default => 1

  def index
    @organizations_catalog_presenter = OrganizationsCatalogPresenter.new
  end

  def show
    unless request.subdomain.blank?
      @organization = OrganizationDecorator.find_by_subdomain!(request.subdomain)
    else
      @organization = OrganizationDecorator.find(params[:id])
    end

    @presenter = ShowingsPresenter.new(organization_ids: [@organization.id], order_by: params[:order_by], page: params[:page])

    render partial: @presenter.partial, layout: false and return if request.xhr?
    render layout: "organization_layouts/#{@organization.subdomain}" if @organization.subdomain? && template_exists?(@organization.subdomain, 'layouts/organization_layouts')
  end

  def photogallery
    @organization = OrganizationDecorator.find(params[:id])
  end

  def affiche
    @organization = OrganizationDecorator.find(params[:id])
    @presenter = AfficheCollection.new(params.merge(list_settings: cookies['znaigorod_affiches_list_settings']).merge(organization: @organization))
    render partial: @presenter.view_partial, layout: false and return if request.xhr?
  end

  def tour
    @organization = OrganizationDecorator.find(params[:id])
  end
end
