class SaunasController < ApplicationController
  def index
    cookie = cookies['_znaigorod_sauna_list_settings'].to_s
    settings_from_cookie = {}
    settings_from_cookie = Rack::Utils.parse_nested_query(cookie) if cookie.present?
    @presenter = SaunaHallsPresenter.new(settings_from_cookie.merge(params))
    render partial: 'sauna_posters', layout: false and return if request.xhr?
  end
end
