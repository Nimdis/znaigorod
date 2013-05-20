Znaigorod::Application.routes.draw do
  resources :tickets, :only => [] do
    resources :payments, :only => [:new, :create]
  end

  scope 'robokassa' do
    post 'paid'    => 'robokassa#paid'
    post 'success' => 'robokassa#success'
    post 'fail'    => 'robokassa#fail'
  end

  Organization.available_suborganization_kinds.each do |kind|
    resources kind.pluralize, :only => [:new, :create] do
      resources :sms_claims, :only => [:new, :create]
    end
  end
end
