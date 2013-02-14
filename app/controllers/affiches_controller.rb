# encoding: utf-8

class AffichesController < ApplicationController
  def index
    @presenter = AffichesPresenter.new(params)
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
