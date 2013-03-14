# encoding: utf-8

Znaigorod::Application.routes.draw do
  mount Affiches::API => '/'

  namespace :manage do
    post 'red_cloth' => 'red_cloth#show'

    resources :search, :only => :index

    resources :sessions, :only => [:new, :create, :destroy]

    Affiche.descendants.each do |type|
      resources type.name.underscore.pluralize
    end

    resources :contests do
      resources :works, :except => [:index, :show]
    end

    resources :affiches do
      resources :attachments, :only => [:new, :create, :destroy, :edit, :update]
      resources :images, :only => [:new, :create, :destroy, :edit, :update]
    end

    resources :posts do
      resources :post_images
    end

    resources :organizations do
      resource :culture, :except => [:index, :show]
      resource :entertainment, :except => [:index, :show]
      resource :meal, :except => [:index, :show]
      resource :sport, :except => [:index, :show]
      resource :creation, :except => [:index, :show]

      resource :billiard, :except => [:index, :show] do
        resources :pool_tables, :except => [:index, :show]
      end

      resource :sauna, :except => [:index, :show] do
        resources :sauna_halls, :except => :index
      end

      resources :sauna_halls, :only => [] do
        resources :images, :only => [:new, :create, :destroy, :edit, :update]
      end

      resources :attachments, :only => [:new, :create, :destroy, :edit, :update]
      resources :images, :only => [:new, :create, :destroy, :edit, :update]
      resources :organizations, :only => [:new, :create, :destroy]
    end

    Organization.available_suborganization_kinds.each do |kind|
      resources kind.pluralize, :only => :index do
        resources :images, :only => [:new, :create, :destroy, :edit, :update]
      end
    end

    get 'statistics' => 'statistics#index'

    namespace :admin do
      resources :users
      post "users/mass_update" => 'users#mass_update', :as => 'user/mass_update'
    end

    root :to => 'organizations#index'
  end

  # legacy urls

  match URI.encode("/meals/доставка готовых блюд"), :to => redirect(URI.encode("/meals/доставка еды"))
  match URI.encode("/meals/доставка готовых блюд/(*query)"), :to => redirect { |params, req|
    URI.encode("/meals/доставка еды/#{params[:query]}")
  }

  # / legacy urls

  get 'search' => 'search#search', :as => :search

  get 'geocoder' => 'geocoder#get_coordinates'

  get 'webcams' => 'webcams#index'

  get 'cooperation' => 'cooperation#index'

  resources :saunas, :only => :index

  resources :affiches, :only => :index

  get 'photogalleries/:period/(*query)' => 'photogalleries#index',
    period: /all|month|week/,
    :as => :photogalleries

  get 'sportsevent/:id' => 'affiches#show', :as => :sports_event
  get 'masterclass/:id' => 'affiches#show', :as => :master_class

  Affiche.descendants.each do |type|
    get "#{type.name.downcase}/:id" => 'affiches#show', :as => "#{type.name.downcase}"
    get "#{type.name.downcase}/:id/photogallery" => 'affiches#photogallery', :as => "#{type.name.downcase}_photogallery"
    get "#{type.name.downcase}/:id/trailer" => 'affiches#trailer', :as => "#{type.name.downcase}_trailer"
  end

  # legacy organization urls
  constraints(:id => /\d+/) do
    get 'organizations/:id' => redirect { |params, req|
      o = Organization.find(params[:id])
      "/organizations/#{o.slug}"
    }
  end

  resources :organizations, :only => :show do
    get :photogallery, :tour, :on => :member
    get 'affiche/:period/(:on)/(tags/*tags)' => 'organizations#affiche',
      :defaults => {period: :all},
      :period => /today|weekly|weekend|all|daily/, :on => :member, :as => :affiche
  end

  #get ':organization_class/(:category)/(*query)' => 'organizations#index',
      #:organization_class => /organizations|meals|entertainments|cultures|sports|creations|saunas/, :as => :organizations
  resources :organizations, :only => :index

  Organization.available_suborganization_kinds.each do |kind|
    resources kind.pluralize, :only => :index
  end

  resources :posts, :only => [:index, :show] do
    get :draft, :on => :collection, :as => :draft
  end

  resources :contests, :only => :show do
    resources :works, :only => :show
  end

  get 'feedback' => 'feedback#new', :as => :new_feedback
  post 'feedback' => 'feedback#create', :as => :create_feedback

  constraints(Subdomain) do
    match '/' => 'organizations#show'
  end

  root :to => 'application#main_page'

  match "/auth/:provider/callback" => "manage/sessions#create"

  mount ElVfsClient::Engine => '/'

  # legacy urls

  get 'affiches' =>  redirect('/affiches/all')

  get 'affiches/:id' => redirect { |params, req|
    a = Affiche.find(params[:id])
    "/#{a.class.model_name.downcase}/#{a.slug}"
  }

  # / legacy urls
end
