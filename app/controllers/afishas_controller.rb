# encoding: utf-8

class AfishasController < ApplicationController
  def index
    cookie = cookies['znaigorod_afishas_list_settings'].to_s
    settings = {}
    settings = JSON.parse(cookie) if cookie.present? && cookie.length > 1

    @presenter = AfishaPresenter.new(params.merge(settings))

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
    @afisha.create_page_visit(request.session_options[:id], current_user)
  end

end
