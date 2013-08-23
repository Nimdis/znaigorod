# encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :banners, :hot_offers, :page, :per_page

  layout :resolve_layout

  private

  def resolve_layout
    request.xhr? ? false : 'public'
  end

  def page
    params[:page].blank? ? 1 : params[:page].to_i
  end

  def per_page
    @per_page ||= Settings['pagination.per_page'] || 10
  end

  def paginate_options
    {
      :page       => page,
      :per_page   => per_page
    }
  end

  def hot_offers
    all_offers[-6..-1]
  end

  def all_offers
    [
      'meals/Пиццерии',
      'meals/Завтраки',
      'meals/Бизнес-Ланч',
      'meals/Детские Кафе',
      'entertainments/Бильярдные Залы',
      'meals/Столовые',
      'meals/Кофейни',
      'meals/Wi-Fi',
      'entertainments/Боулинг',
    ]
  end

  def banners
    Affiche.with_images.with_showings.latest(4)
  end
end
