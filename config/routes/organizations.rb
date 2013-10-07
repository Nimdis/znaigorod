# encoding: utf-8

Znaigorod::Application.routes.draw do

  resources :organizations, :only => [:index, :show] do
    get :in_bounding_box, :on => :collection
    get :details_for_balloon, :on => :member
    put 'change_vote' => 'votes#change_vote', :as => :change_vote
    put 'destroy_visits' => 'visits#destroy_visits', :as => :destroy_visits
    get 'liked' => 'votes#liked', :as => :liked

    resources :comments, :only => [:new, :create, :show]
    resources :visits

    resources :user_ratings, :only => [:new, :create, :edit, :update, :show]
  end

  resources :saunas, :only => :index

  get '/saunas/sauny', :to => redirect('/saunas')

  Organization.basic_suborganization_kinds.each do |kind|
    # redirects from /kind?categories[]=...
    get "/#{kind.pluralize}",
      :constraints => lambda { |req| req.query_parameters.has_key?('categories') },
      :to =>  redirect { |params, req|
        category = req.query_parameters['categories'].first.mb_chars.downcase
        other_parameters = req.query_parameters.to_h
        other_parameters.delete('categories')
        parameter_string = other_parameters.to_param
        parameter_string.insert(0, "?") unless parameter_string.empty?
        "/#{kind.pluralize}/#{FromRussianToParam.convert(category)}" + parameter_string

      }

      # short categories urls
      begin
        HasSearcher.searcher(kind.pluralize.to_sym).facet("#{kind}_category").rows.map do |row|
          next if kind == 'sauna'
          get "/#{kind.pluralize}/#{FromRussianToParam.convert(row.value)}" => 'suborganizations#index',
          :as => "#{kind.pluralize}_#{FromRussianToParam.convert(row.value).pluralize}".to_sym,
          :constraints => {:kind => kind},
          :defaults => {:kind => kind, :categories => [row.value]}
        end
      rescue Exception => e
        p e
      end
      get "/#{kind.pluralize}" => 'suborganizations#index', :as => kind.pluralize, :constraints => { :kind => kind }, :defaults => { :kind => kind }

    # from legacy
    get "/#{kind.pluralize}/(:category)/(*query)",
      :to => redirect { |params, req|
        url = "/#{kind.pluralize}"
        if params[:category] == 'all'
          parameters = {}
          parameters.tap do |hash|
            keyword = ''
            params[:query].split('/').each do |word|
              keyword = word and hash[keyword] ||= [] and next if ['categories'].include?(word)
              hash[keyword] << word if hash[keyword]
            end
          end
          parameters['categories'] ||= []
          if parameters['categories'] == ['сауны']
            url = '/saunas'
          else
            url += "/#{FromRussianToParam.convert(parameters['categories'].first)}" if parameters['categories'].any?
          end
        else
          if params[:category] == 'сауны'
            url = '/saunas'
          else
            url += "/#{FromRussianToParam.convert(params[:category]).gsub(" ", "_")}"
          end
        end
        URI.encode(url)
    }

    resources kind.pluralize, :only => [] do
      resources :sms_claims, :only => [:new, :create]
    end
  end

  get '/entertainments/bilyardnye_zaly' => 'suborganizations#index', :as => :billiards, :constraints => { :kind => 'entertainments' }, :defaults => { :kind => 'entertainments' }

  get 'organizations/:id/affiche/all' => redirect { |params, req|
    o = Organization.find(params[:id])
    "/organizations/#{o.slug}"
  }

  get 'organizations/:id/tour' => redirect { |params, req|
    o = Organization.find(params[:id])
    "/organizations/#{o.slug}"
  }

  get 'organizations/:id/photogallery' => redirect { |params, req|
    o = Organization.find(params[:id])
    "/organizations/#{o.slug}"
  }
end
