class SuborganizationsController < ApplicationController
  def index
    kind = (Organization.available_suborganization_kinds & [params[:kind]]).try(:first)
    klass = "#{kind.pluralize}_presenter".classify.constantize
    cookie = cookies['_znaigorod_organization_list_settings'].to_s
    settings_from_cookie = {}
    settings_from_cookie = Rack::Utils.parse_nested_query(cookie) if cookie.present?
    @presenter = klass.new(settings_from_cookie.merge(params))

    render partial: 'organizations/organizations_list', layout: false and return if request.xhr?
  end
end
