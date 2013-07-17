# encoding: utf-8

module Mobile
  class API < Grape::API
    prefix 'mobile'
    format :json

    helpers do

      def site_url
        'http://znaigorod.ru'
      end

      def base_path
        "#{site_url}/mobile/affisha"
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

      def affishes(kind, period, sorting, page)
        ShowingsPresenter.new(:categories => (kind == 'all' ?  [] : [kind.singularize]), :period => period, :order_by => sorting, :page => page )
      end

      def affisha_updated_at(affisha)
        array = [affisha.updated_at]
        array << affisha.showings.actual.map(&:updated_at) if affisha.showings.actual.any?
        array << affisha.tickets.map(&:updated_at) if affisha.has_tickets_for_sale?
        array.flatten.max
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

        { lastUpdate: api_version, categories: categories }
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

      params do
        optional :page, :type => Integer
      end

      get ':kind/:period/:sorting' do
        affishes = affishes(params[:kind], params[:period], params[:sorting], params[:page] || 1)
        {
          lastUpdate: affishes.collection.map { |affisha| affisha_updated_at(affisha.affiche) }.max,
          urlModifier: affishes.paginated_collection.next_page ? "?page=#{affishes.paginated_collection.next_page}" : '',
          affishes: affishes.collection.map do |affisha|
            {
              :url => "#{base_path}/#{affisha.slug}",
              :name => affisha.title,
              :when => affisha.human_when,
              :price => affisha.human_price,
              :place => affisha.places.map(&:title).join("; "),
              :image => affisha.poster_url,
              :expires => affisha.distribution_ends_on? ? affisha.distribution_ends_on : affisha.showings.map(&:starts_at).max,
              lastUpdate: affisha_updated_at(affisha.affiche)
            }
          end
        }
      end

      get ':slug' do
        affisha = Affiche.find(params[:slug])
        decorated_affisha = AfficheDecorator.new affisha
        {
          id: affisha.slug,
          link: "#{site_url}/#{affisha.class.name.downcase}/#{affisha.slug}",
          name: affisha.title,
          image: affisha.poster_url,
          description: affisha.html_description,
          expires: affisha.distribution_ends_on? ? affisha.distribution_ends_on : affisha.showings.map(&:starts_at).max,
          showings: decorated_affisha.showings.actual.map { |showing|
            decorated_showing = ShowingDecorator.new(showing)
            {
              date: decorated_showing.human_when,
              price: decorated_showing.human_price,
              place: showing.organization.present? ? "#{showing.organization.title}, #{showing.organization.address.to_s}" : showing.place
            }
          },
          tickets: decorated_affisha.tickets.map { |ticket|
            if ticket.copies.for_sale.count > 0
              {
                original_price: ticket.original_price,
                price: ticket.price,
                count_for_sale: ticket.copies.for_sale.count
              }
            end
          }.compact,
          lastUpdate: affisha_updated_at(decorated_affisha)
        }
      end

    end
  end
end
