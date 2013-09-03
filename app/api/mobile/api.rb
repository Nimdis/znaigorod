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
        DateTime.new(2013, 8, 31, 21, 00, 00, '+7')
      end

      def periods
        [
          { period: 'Все',  urlModifier:  "period=all"},
          { period: 'Сегодня',  urlModifier:  "period=today"},
          { period: 'На неделе',  urlModifier:  "period=week"},
          { period: 'На выходных',  urlModifier:  "period=weekend"}
        ]
      end

      def affishes(kind, period, sorting, page)
        period ||= 'all'
        sorting ||= 'creation'
        AfishaPresenter.new(:categories => (kind == 'all' ?  [] : [kind]), :period => period, :order_by => sorting, :page => page )
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
        categories = [ {category: 'Все мероприятия', url: "#{base_path}/list/all" }]
        categories += Afisha.kind.values.map do |kind|
          {
            category: kind.text,
            url: "#{base_path}/list/#{kind}",
          }
        end

        { lastUpdate: api_version, categories: categories }
      end

      get '/periods' do
        { lastUpdate: api_version, periods: periods }
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
        optional :period, :type => String
        optional :sorting, :type => String
      end

      get 'list/:kind' do
        affishes = affishes(params[:kind], params[:period], params[:sorting], params[:page] || 1)
        {
          lastUpdate: affishes.decorated_collection.map { |affisha| affisha_updated_at(affisha.afisha) }.max,
          next_page: affishes.paginated_collection.next_page ? "page=#{affishes.paginated_collection.next_page}" : '',
          affishes: affishes.decorated_collection.map do |affisha|
            {
              :url => "#{base_path}/#{affisha.slug}",
              :name => affisha.title,
              :when => affisha.human_when.replace_special_html_chars,
              :price => affisha.human_price.replace_special_html_chars,
              :place => affisha.places.map(&:title).join("; "),
              :image => affisha.poster_url.gsub(/(\/files\/\d+\/)\d+-\d+\//){"#{$1}74-100!n/"}.gsub(/(\/files\/\d+\/region\/(\d+|\/){8})/){"#{$1}74-100/"},
              :expires => affisha.distribution_ends_on? ? affisha.distribution_ends_on : affisha.showings.map(&:starts_at).max,
              lastUpdate: affisha_updated_at(affisha.afisha),
              :ticket_link => affisha.tickets.map(&:copies_for_sale).flatten.any? ? "#{site_url}/afisha/#{affisha.slug}#buy_ticket" : nil,
            }
          end
        }
      end

      get ':slug' do
        affisha = Afisha.find(params[:slug])
        decorated_affisha = AfishaDecorator.new affisha
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
