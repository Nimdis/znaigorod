# encoding: utf-8

class AffichesController < ApplicationController
  def index
    @presenter = ShowingsPresenter.new(params)

    if request.xhr?
      if params[:page]
        @presenter = ShowingsPresenter.new(params)
        render partial: @presenter.partial, layout: false and return
      end

      @affiche_today = AfficheToday.new(params[:kind])
      render :partial => 'affiche_today', :layout => false and return
    else

      @presenter = ShowingsPresenter.new(params)
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
