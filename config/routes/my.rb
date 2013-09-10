Znaigorod::Application.routes.draw do
  namespace :my do
    resources :sessions,  :only => [:new, :destroy]

    get '/afisha/available_tags' => 'afishas#available_tags', :as => :available_tags, :controller => 'afishas'

    resources :notification_messages, :only => :index do
      put 'change_message_status' => 'notification_messages#change_message_status', :on => :member, :as => :change_status
    end

    resources :dialogs, :only => [:index, :show]

    resources :invite_messages, :only => [:index, :update, :create, :show] do
      put 'change_message_status' => 'invite_messages#change_message_status', :on => :member, :as => :change_status
    end

    resources :private_messages, :only => [:new, :create, :show] do
      put 'change_message_status' => 'private_messages#change_message_status', :on => :member, :as => :change_status
    end

    resource :account, :only => [:show, :edit, :update]
    resources :invitations, :except => [:index, :edit, :update]

    resources :afisha, :except => [:index, :show], :controller => 'afishas' do
      get 'edit/step/:step' => 'afishas#edit', :defaults => { :step => 'first' }, :on => :member, :as => :edit_step
      get 'available_tags' => 'afishas#available_tags', :as => :available_tags
      get 'preview_video'

      put 'social_gallery' => 'afishas#social_gallery', :on => :member, :as => :social_gallery
      put 'moderate' => 'afishas#send_to_moderation', :on => :member, :as => :moderate
      put 'publish'  => 'afishas#send_to_published', :on => :member, :as => :publish
      put 'draft' => 'afishas#send_to_draft', :on => :member, :as => :draft

      delete 'destroy_image', :on => :member, :as => :destroy_image

      resources :gallery_images, :only => [:create, :destroy] do
        delete 'destroy_all', :on => :collection, :as => :destroy_all
      end

      resources :gallery_files, :only => [:create, :destroy] do
        delete 'destroy_all', :on => :collection, :as => :destroy_all
      end

      resources :gallery_social_images, :only => :destroy do
        delete 'destroy_all', :on => :collection, :as => :destroy_all
      end

      resources :showings

      resources :bets, :only => :create do
        resources :bet_payments, :only => [:new, :create]

        put :approve, :on => :member
        put :cancel, :on => :member
      end
    end

    get "/afisha/:id" => "afishas#show", :as => :afisha_show, :controller => 'afishas'

    root to: 'accounts#show'
  end
end
