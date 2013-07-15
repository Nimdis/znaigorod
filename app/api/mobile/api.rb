# encoding: utf-8

module Mobile
  class API < Grape::API
    prefix 'mobile'
    format :json

    helpers do

      def base_path
        "http://znaigorod.ru/mobile/affisha"
      end

      def api_version
        DateTime.new(2013, 7, 15, 16, 10, 00, '+7')
      end

      def subcategories(kind)
        [
          { category: 'Все',  url:  "#{base_path}/#{kind}/all"},
          { category: 'Сегодня',  url:  "#{base_path}/#{kind}/today"},
          { category: 'На неделе',  url:  "#{base_path}/#{kind}/week"},
          { category: 'На выходных',  url:  "#{base_path}/#{kind}/weekend"}
        ]
      end
    end

    resource :affisha do
      get '/categories' do
        categories = [ {category: 'Все мероприятия', url: "#{base_path}/all", subcategories: subcategories('all') }]
        categories += Affiche.ordered_descendants.map do |affiche_class|
          {
            category: affiche_class.model_name.human,
            url: "#{base_path}/#{affiche_class.name.downcase.pluralize}",
            subcategories: subcategories(affiche_class.name.downcase.pluralize)
          }
        end
        {
          lastUpdate: api_version,
          categories: categories
        }
      end

      get '/sortings' do
        {
          lastUpdate: api_version,
          methods: [
            { name: 'По новизне', urlModifier: 'creation' },
            { name: 'По рейтингу', urlModifier: 'rating' },
            { name: 'По ближайшему сеансу', urlModifier: 'starts_at' }
          ]
        }
      end
    end
  end
end
