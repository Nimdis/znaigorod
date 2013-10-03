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

  Organization.basic_suborganization_kinds.each do |kind|
    get "/#{kind.pluralize}" => 'suborganizations#index', :as => kind.pluralize, :constraints => { :kind => kind }, :defaults => { :kind => kind }
  end
  get '/entertainments' => 'suborganizations#index', :as => :billiards, :constraints => { :kind => 'entertainments' }, :defaults => { :kind => 'entertainments' }

  Organization.available_suborganization_kinds.each do |kind|
    resources kind.pluralize, :only => [:new, :create] do
      resources :sms_claims, :only => [:new, :create]
    end
  end

  # from legacy
  get ':organization_class/(:category)/(*query)',
    :organization_class => /meals|entertainments|cultures|sports|creations|saunas/,
    :to => redirect { |params, req|
      url = "/#{params[:organization_class]}?order_by=popularity"
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
          parameters['categories'].each do |cat|
            url += "&categories[]=#{cat}"
          end
        end
      else
        if params[:category] == 'сауны'
          url = '/saunas'
        else
          url += "&categories[]=#{params[:category]}"
        end
      end
      URI.encode(url)
  }

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
