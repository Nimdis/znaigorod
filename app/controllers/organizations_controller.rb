# encoding: utf-8

class OrganizationsController < ApplicationController
  has_scope :page, :default => 1

  before_filter :allow_cross_domain_access

  def index
    respond_to do |format|
      format.html do
        cookie = cookies['_znaigorod_organization_list_settings'].to_s
        settings_from_cookie = {}
        settings_from_cookie = Rack::Utils.parse_nested_query(cookie) if cookie.present?
        @presenter = OrganizationsCatalogPresenter.new(settings_from_cookie.merge(params))

        render partial: 'organizations/organizations_posters', layout: false and return if request.xhr?
      end
      format.json do
        searcher = HasSearcher.searcher(:manage_organization, params).paginate(:page => params[:page], :per_page => 10)

        render :json => searcher.results
      end
    end
  end

  def show
    if request.subdomain.blank? || !Organization.exists?(:subdomain => request.subdomain)
      @organization = Organization.find(params[:id])
    else
      @organization = Organization.find_by_subdomain(request.subdomain)
    end
    @organization.delay.create_page_visit(request.session_options[:id], request.user_agent, current_user)

    @organization = OrganizationDecorator.decorate @organization
    @visits = @organization.visits.page(1).per(5)

    case @organization.priority_suborganization_kind
    when 'sauna'
      @presenter = SaunaHallsPresenter.new
    else
      klass = "#{@organization.priority_suborganization_kind.pluralize}_presenter".classify.constantize
      @presenter = klass.new(:categories => [@organization.priority_suborganization.categories.first.mb_chars.downcase])
    end
    cookie = cookies['_znaigorod_afisha_list_settings'].to_s
    settings_from_cookie = {}
    settings_from_cookie = Rack::Utils.parse_nested_query(cookie) if cookie.present?
    @afisha_presenter = AfishaPresenter.new(organization_ids: [@organization.id], order_by: settings_from_cookie.merge(params)['order_by'], page: params[:page])

    render partial: @afisha_presenter.partial, locals: {afishas: @afisha_presenter.decorated_collection}, layout: false and return if request.xhr?
    render layout: "organization_layouts/#{@organization.subdomain}" if @organization.subdomain? && template_exists?(@organization.subdomain, 'layouts/organization_layouts')
  end

  def photogallery
    @organization = OrganizationDecorator.find(params[:id])
  end

  def affiche
    @organization = OrganizationDecorator.find(params[:id])
    @presenter = AfficheCollection.new(params.merge(list_settings: cookies['_znaigorod_afisha_list_settings']).merge(organization: @organization))
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
