Znaigorod::Application.routes.draw do

  namespace :manage do
    post 'red_cloth' => 'red_cloth#show'

    resources :comments,  :only => [:index, :destroy]
    resources :search,    :only => :index
    resources :sessions,  :only => [:new, :create, :destroy]


    Affiche.descendants.each do |type|
      resources type.name.underscore.pluralize
    end
    resources :affiches, only: [] do
      resources :tickets
    end

    resources :contests do
      resources :works, :except => [:index, :show]
    end

    resources :coupons

    resources :affiches do
      resources :attachments, :except => [:index, :show]
      resources :images,      :except => [:index, :show]
    end

    resources :posts do
      resources :post_images
    end

    get 'organizations/rated' => 'organizations#index', :defaults => { :rated => true }

    resources :organizations do
      Organization.available_suborganization_kinds.each do |kind|
        resource kind, :except => [:index] do
          resources :services, :except => [:index, :show]
        end
      end

      resource :meal do
        resources :menus, :except => [:index, :show]
      end

      resource :billiard, :only => [] do
        resources :pool_tables, :except => [:index, :show]
      end

      resource :sauna, :except => [] do
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

    resources :tickets, only: :index do
      get ':by_state' => 'tickets#index', :on => :collection, :as => :with_state
    end

    resources :payments, :only => :index

    get 'statistics' => 'statistics#index'

    namespace :admin do
      resources :users
      post "users/mass_update" => 'users#mass_update', :as => 'user/mass_update'
    end

    root :to => 'organizations#index'
  end

end
