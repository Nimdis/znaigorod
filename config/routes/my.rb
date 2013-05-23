Znaigorod::Application.routes.draw do
  namespace :my do

    resources :affiches do
      get 'edit/step/:step' => 'affiches#edit', :defaults => { :step => 'first' }, :on => :member, :as => :edit_step
    end

    root to: 'affiches#new'
  end
end
