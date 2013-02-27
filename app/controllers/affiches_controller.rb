# encoding: utf-8

class AffichesController < ApplicationController
  def index
    @showings_presenter = ShowingsPresenter.new(params)

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
