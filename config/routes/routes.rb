require 'sidekiq/web'

Znaigorod::Application.routes.draw do
  mount Affiches::API => '/'
  mount Mobile::API => '/'
  mount ElVfsClient::Engine => '/'
  mount Sidekiq::Web, at: "/sidekiq"

  devise_for :users, :controllers => { :omniauth_callbacks =>  'omniauth_callbacks' }

  devise_scope :user do
    delete '/users/sign_out' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  %w[services benefit statistics our_customers].each do |method|
    get method => "cooperation##{method}"
  end

  get '/cooperation' => redirect('/services')

  get 'accounts_search' => 'accounts_search#show',         :as => :accounts_search
  get 'geocoder' => 'geocoder#get_coordinates'
  get 'search' => 'search#search',                :as => :search
  get 'yamp_geocoder' => 'geocoder#get_yamp_coordinates'

  resources :afisha, :only => [], :controller => 'afishas' do
    resources :comments, :only => [:new, :show, :create]
    resources :visits

    get 'liked' => 'votes#liked', :as => :liked
    get 'photogallery' => 'afisha#photogallery', :as => :photogallery
    get 'trailer' => 'afisha#trailer', :as => :trailer

    put 'change_vote' => 'votes#change_vote', :as => :change_vote
    put 'destroy_visits' => 'visits#destroy_visits', :as => :destroy_visits
  end

  get '/afisha' => 'afishas#index', :as => :afisha_index, :controller => 'afishas'
  get '/afisha/:id' => 'afishas#show', :as => :afisha_show, :controller => 'afishas'

  get '/tickets' => redirect('/afisha?has_tickets=true')

  resources :coupons, :only => [:index, :show] do
    get 'page/:page', :action => :index, :on => :collection
    put 'change_vote' => 'votes#change_vote', :as => :change_vote
    put 'liked' => 'votes#liked', :as => :liked

    resources :comments, :only => [:new, :create, :show]
  end

  resources :comments, :only => [] do
    put 'change_vote' => 'votes#change_vote', :as => :change_vote
    put 'liked' => 'votes#liked', :as => :liked
  end

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

  Organization.basic_suborganization_kinds.each do |kind|
    get "/#{kind.pluralize}" => 'suborganizations#index', :as => kind.pluralize, :constraints => { :kind => kind }, :defaults => { :kind => kind }
  end
  get '/entertainments' => 'suborganizations#index', :as => :billiards, :constraints => { :kind => 'entertainments' }, :defaults => { :kind => 'entertainments' }

  resources :posts, :only => [:index, :show] do
    get :draft, :on => :collection, :as => :draft

    put 'change_vote' => 'votes#change_vote', :as => :change_vote
    get 'liked' => 'votes#liked', :as => :liked

    resources :comments, :only => [:new, :create, :show]
  end

  resources :contests, :only => [:index, :show] do
    resources :works, :only => :show do
      put 'change_vote' => 'votes#change_vote', :as => :change_vote
      get 'liked' => 'votes#liked', :as => :liked
    end
  end

  resources :works, :only => [] do
    resources :comments, :only => [:new, :create, :show]
  end

  resources :service_payments, :only => [:new, :create]

  resources :accounts, :only => [:index, :show] do
    put 'change_friendship' => 'friends#change_friendship', :as => :change_friendship

    resources :events, :only => :index
    resources :comments, :only => :index
    resources :friends, :only => :index
    resources :votes, :only => :index
    resources :visits, :only => :index
  end

  resources :webcams, :only => [:index, :show]

  get 'feedback' => 'feedback#new', :as => :new_feedback
  post 'feedback' => 'feedback#create', :as => :create_feedback

  match '/' => redirect{|p, req| "#{req.url.sub(req.subdomain+'.', '')}organizations/#{Organization.find_by_subdomain(req.subdomain).slug}"}, :constraints => lambda{|r| r.subdomain.present? && Organization.pluck(:subdomain).uniq.delete_if{|s| s.nil? || s.blank?}.include?(r.subdomain) }

  match "/auth/:provider/callback" => "manage/sessions#create"

  root :to => 'afishas#index'
end
