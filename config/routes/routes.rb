Znaigorod::Application.routes.draw do
  mount Affiches::API => '/'
  mount Mobile::API => '/'
  mount ElVfsClient::Engine => '/'

  devise_for :users, :controllers => { :omniauth_callbacks =>  'omniauth_callbacks' }

  devise_scope :user do
    delete '/users/sign_out' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  get 'cooperation'       => 'cooperation#index'
  get 'geocoder'          => 'geocoder#get_coordinates'
  get 'yamp_geocoder'     => 'geocoder#get_yamp_coordinates'
  get 'search'            => 'search#search',              :as => :search
  get 'webcams'           => 'webcams#index'

  resources :afisha, :only => [], :controller => 'afishas' do

    resources :comments, :only => [:new, :show, :create]

    get "photogallery" => "afisha#photogallery", :as => :photogallery
    get "trailer" => "afisha#trailer", :as => :trailer

    get "visitors" => "visits#visitors", :as => :visitors
    put "change_visit" => "visits#change_visit", :as => :change_visit
    put "change_vote" => "votes#change_vote", :as => :change_vote
    get "liked" => "votes#liked", :as => :liked
    resources :visits, :only => [:new, :create, :show, :update]
  end

  get "/afisha" => "afishas#index", :as => :afisha_index, :controller => 'afishas'
  get "/afisha/:id" => "afishas#show", :as => :afisha_show, :controller => 'afishas'

  resources :saunas,   :only => :index

  resources :tickets,  :only => :index do
    get 'page/:page', :action => :index, :on => :collection
  end

  resources :coupons,  :only => [:index, :show] do
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
    put 'change_visit' => 'visits#change_visit', :as => :change_visit
    get 'visitors' => 'visits#visitors', :as => :visitors
    get 'liked' => 'votes#liked', :as => :liked

    resources :comments, :only => [:new, :create, :show]
    resources :visits, :only => [:new, :create, :show, :update]

    resources :user_ratings, :only => [:new, :create, :edit, :update, :show]
  end

  get 'photogalleries/:period/(*query)' => 'photogalleries#index',  :as => :photogalleries, :period => /all|month|week/

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

  resources :contests, :only => :show do
    resources :works, :only => :show do
      put 'change_vote' => 'votes#change_vote', :as => :change_vote
      get 'liked' => 'votes#liked', :as => :liked
    end
  end

  resources :works, :only => [] do
    resources :comments, :only => [:new, :create, :show]
  end

  resources :service_payments, :only => [:new, :create]

  resources :users, :only => [:index, :show] do
    resources :events, :only => :index
    resources :comments, :only => :index
    resources :payments, :only => :index
    resources :visits, :only => :index
    resources :votes, :only => :index
  end

  get 'feedback' => 'feedback#new', :as => :new_feedback
  post 'feedback' => 'feedback#create', :as => :create_feedback

  match '/' => redirect{|p, req| "#{req.url.sub(req.subdomain+'.', '')}organizations/#{Organization.find_by_subdomain(req.subdomain).slug}"}, :constraints => lambda{|r| r.subdomain.present? && Organization.pluck(:subdomain).uniq.delete_if{|s| s.nil? || s.blank?}.include?(r.subdomain) }

  match "/auth/:provider/callback" => "manage/sessions#create"

  root :to => 'application#main_page'
end
