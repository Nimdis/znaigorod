Znaigorod::Application.routes.draw do
  mount Affiches::API => '/'
  mount Mobile::API => '/'

  resources :afisha, :only => :show, :controller => :afishas

  resources :afisha, :only => [], :controller => 'afishas' do
    resources :comments, :only => [:new, :show, :create]
    resources :visits

    get 'liked' => 'votes#liked', :as => :liked
    get 'photogallery' => 'afisha#photogallery', :as => :photogallery
    get 'trailer' => 'afisha#trailer', :as => :trailer

    put 'change_vote' => 'votes#change_vote', :as => :change_vote
    put 'destroy_visits' => 'visits#destroy_visits', :as => :destroy_visits
  end

  get "/afisha",
  :constraints => lambda { |req| req.query_parameters.has_key?('has_tickets') },
  :to =>  redirect { |params, req|
    other_parameters = req.query_parameters.to_h
    other_parameters.delete('has_tickets')
    parameter_string = other_parameters.to_param
    parameter_string.insert(0, "?") unless parameter_string.empty?
    "/afisha/bilety" + parameter_string
  }
  get '/tickets', :to => redirect("/afisha/bilety")

  get '/afisha' => 'afishas#index', :as => :afisha_index, :controller => 'afishas'
  get '/afisha/:id' => 'afishas#show', :as => :afisha_show, :controller => 'afishas',
    :constraints => lambda {|request| request.fullpath !~ /^\/afisha\/bilety/ }

  get '/affiches', :to => redirect('/afisha')

  get "/afisha/bilety" => 'afishas#index', :as => :afisha_with_tickets_index, :defaults => {:has_tickets => true}

  Afisha.kind.values.map(&:pluralize).each do |kind|
    get "/#{kind}",
      :constraints => lambda { |req| req.query_parameters.has_key?('has_tickets') },
      :to =>  redirect { |params, req|
        other_parameters = req.query_parameters.to_h
        other_parameters.delete('has_tickets')
        parameter_string = other_parameters.to_param
        parameter_string.insert(0, "?") unless parameter_string.empty?
        "/#{kind.pluralize}/bilety" + parameter_string
      }
    get kind => 'afishas#index', :as => "#{kind}_index", :defaults => { :categories => [kind.singularize], :hide_categories => true }
    get "/#{kind}/bilety" => 'afishas#index', :as => "#{kind}_with_tickets_index", :defaults => { :categories => [kind.singularize], :hide_categories => true, :has_tickets => true }
    match "/#{kind}/all" => redirect("/#{kind}")
  end

  Afisha.kind.values.each do |kind|
    get "#{kind}/:id", :to => redirect { |params, req|
      "/afisha/#{params[:id]}"
    }
    get "#{kind}/:id/photogallery", :to => redirect { |params, req|
      "/afisha/#{params[:id]}#photogallery"
    }
    get "#{kind}/:id/trailer", :to => redirect { |params, req|
      "/afisha/#{params[:id]}#trailer"
    }
  end

  get ':kind/:period/(:on)/(categories/*categories)/(tags/*tags)',
    :kind => /movies|concerts|parties|spectacles|exhibitions|sportsevents|others|affiches|masterclasses/,
    :period => /today|weekly|weekend|all|daily/,
    :to => redirect { |params, req|
      parameters = {}
      parameters['categories'] = []
      (params[:categories] || params[:kind] || "").split('/').each do |word|
        parameters['categories'] << word
      end
      period = case params[:period]
               when 'weekly'
                 'week'
               when 'daly'
                 'all'
               else
                 params[:period]
               end
      url = "/afisha?order_by=popularity&view=posters"
      url += "&period=#{period}"
      parameters['categories'].each do |cat|
        url += "&categories[]=#{cat.singularize}"
      end
      URI.encode(url)
    }
end
