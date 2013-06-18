Znaigorod::Application.routes.draw do
  namespace :my do
    resources :affiches do
      get 'archive', :on => :collection, :as => :archive
      get 'edit/step/:step' => 'affiches#edit', :defaults => { :step => 'first' }, :on => :member, :as => :edit_step
      get 'available_tags'
      get 'preview_video'

      put 'moderate' => 'affiches#send_to_moderation', :on => :member, :as => :moderate
      put 'publish'  => 'affiches#send_to_published', :on => :member, :as => :publish

      delete 'destroy_image', :on => :member, :as => :destroy_image

      resources :gallery_images, :only => [:create, :destroy] do
        delete 'destroy_all', :on => :collection, :as => :destroy_all
      end

      resources :gallery_files, :only => [:create, :destroy] do
        delete 'destroy_all', :on => :collection, :as => :destroy_all
      end

      resources :showings
    end

    root to: 'affiches#index'
  end
end
