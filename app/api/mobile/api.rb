# encoding: utf-8

module Mobile
  class API < Grape::API
    prefix 'mobile'
    format :json

    helpers do
      def subcategories(kind)
        [
          { category: 'Все',  url:  "/mobile/affisha/#{kind}/all"},
          { category: 'Сегодня',  url:  "/mobile/affisha/#{kind}/today"},
          { category: 'На неделе',  url:  "/mobile/affisha/#{kind}/week"},
          { category: 'На выходных',  url:  "/mobile/affisha/#{kind}/weekend"}
        ]
      end
    end

    resources :affisha do
      get '/categories' do
        categories = [ {category: 'Все мероприятия', url: "/mobile/affisha/all", subcategories: subcategories('all') }]
        categories += Affiche.ordered_descendants.map do |affiche_class|
          {
            category: affiche_class.model_name.human,
            url: "/mobile/affisha/#{affiche_class.name.downcase.pluralize}",
            subcategories: subcategories(affiche_class.name.downcase.pluralize)
          }
        end
        {
          lastUpdate: DateTime.new(2013, 7, 15, 16, 10, 00, '+7'),
          categories: categories
        }
      end
    end
  end
end
