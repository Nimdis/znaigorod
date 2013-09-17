# encoding: utf-8

module Affiches
  module Entities
    class Afisha < Grape::Entity
      expose (:title)       { |model, options| AfishaDecorator.new(model).title.gsub(/\u00AD+/,'') }
      expose (:date)        { |model, options| AfishaDecorator.new(model).human_when.gsub(/\u00AD+/,'') }
      expose (:price)       { |model, options| AfishaDecorator.new(model).human_price.gsub(/\u00AD+/,'') }
      expose (:place)       { |model, options| AfishaDecorator.new(model).place.gsub(/\u00AD+/,'') }
      expose (:kind)        { |model, options| AfishaDecorator.new(model).kind.map(&:text).join(', ').gsub(/\u00AD+/,'') }
      expose (:url)         { |model, options| "#{Settings['app.host']}/afisha/#{model.slug}" }
      expose (:poster_url)  { |model, options| AfishaDecorator.new(model).resized_image_url(model.poster_image_url, 290, 390) }
    end
  end

  class API < Grape::API
    prefix 'api'
    format :json

    resource :popular do
      get do
        present HasSearcher.searcher(:showings).order_by_rating.actual.results.map(&:afisha).first(6), :with => Entities::Afisha
      end
    end
  end
end
