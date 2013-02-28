# encoding: utf-8

class AffichesController < ApplicationController
  def index
    cookie = cookies['znaigorod_affiches_list_settings'].to_s
    settings = {}
    settings = JSON.parse(cookie) if cookie.present? && cookie.length > 1

    @showings_presenter = ShowingsPresenter.new(params.merge(settings))

    if request.xhr?
      if params[:page]
        render partial: @showings_presenter.partial, layout: false and return
      end

      render :partial => 'affiche_today', :layout => false and return
    end
  end

  def show
    @affiche = AfficheDecorator.new Affiche.find(params[:id])
  end

  def photogallery
    @affiche = AfficheDecorator.new Affiche.find(params[:id])
  end

  def trailer
    @affiche = AfficheDecorator.new Affiche.find(params[:id])
  end
end
