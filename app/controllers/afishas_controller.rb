# encoding: utf-8

class AfishasController < ApplicationController
  def index
    cookie = cookies['_znaigorod_afisha_list_settings'].to_s
    settings_from_cookie = {}
    settings_from_cookie = Rack::Utils.parse_nested_query(cookie) if cookie.present?

    @presenter = AfishaPresenter.new(settings_from_cookie.merge(params))

    if request.xhr?
      if params[:page]
        render partial: @presenter.partial, layout: false and return
      end

      render :partial => 'afisha_today', :layout => false and return
    end
  end

  def show
    @afisha = AfishaDecorator.new Afisha.find(params[:id])
    @presenter = AfishaPresenter.new(params)
    @afisha.delay.create_page_visit(request.session_options[:id], current_user)
  end

end
