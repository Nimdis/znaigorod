# encoding: utf-8

class OrganizationsController < ApplicationController
  has_scope :page, :default => 1

  before_filter :allow_cross_domain_access

  def index
    respond_to do |format|
      format.html { @presenter = OrganizationsCatalogPresenter.new(:kind => :organization) }
      format.json do
        searcher = HasSearcher.searcher(:manage_organization, params).paginate(:page => params[:page], :per_page => 10)

        render :json => searcher.results
      end
    end
  end

  def show
    unless request.subdomain.blank?
      @organization = OrganizationDecorator.find_by_subdomain!(request.subdomain)
    else
      @organization = OrganizationDecorator.find(params[:id])
    end

    @organization.create_page_visit(request.session_options[:id])

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

  def in_bounding_box
    searcher = HasSearcher.searcher(:organizations, params).
      with_logotype.
      order_by_rating.
      paginate(page: 1, per_page: 100)

    data = OrganizationDecorator.decorate(searcher.results).map do |organization|
      {
        id: organization.id,
        latitude: organization.address.latitude,
        longitude: organization.address.longitude,
        category: Russian.translit(organization.category.split(',')[0].to_s.squish.gsub(' ', '_').gsub('-', '_')).downcase,
        title: organization.title,
      }
    end

    render :json => data
  end

  def details_for_balloon
    organization = OrganizationDecorator.decorate(Organization.find(params[:id]))
    data = {
      address: organization.address.to_s,
      logo: organization.logotype_url,
      phones: organization.decorated_suborganizations.first.decorated_phones,
      schedule_today: organization.decorated_suborganizations.first.schedule_today,
      title: organization.title.text_gilensize,
      url: organization.show_url,
    }

    render :json => data
  end

  def allow_cross_domain_access
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

end
