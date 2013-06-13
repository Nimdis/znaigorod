Znaigorod::Application.routes.draw do
  namespace :my do
    resources :affiches do
      get 'edit/step/:step' => 'affiches#edit', :defaults => { :step => 'first' }, :on => :member, :as => :edit_step
      get 'available_tags'

      put 'moderate' => 'affiches#send_to_moderation'
      put 'publish'  => 'affiches#send_to_published'

      delete 'destroy_image', :on => :member, :as => :destroy_image

      resources :gallery_images, :only => [:create, :destroy] do
        delete 'destroy_all', :on => :collection, :as => :destroy_all
      end

      resources :gallery_files, :only => [:create, :destroy] do
        delete 'destroy_all', :on => :collection, :as => :destroy_all
      end
    end

    root to: 'affiches#index'
  end
end
