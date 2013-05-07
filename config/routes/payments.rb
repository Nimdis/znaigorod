Znaigorod::Application.routes.draw do
  resources :ticket_infos, only: [] do
    resources :payments, only: [:new, :create]
  end

  scope 'robokassa' do
    post 'paid'    => 'robokassa#paid'
    post 'success' => 'robokassa#success'
    post 'fail'    => 'robokassa#fail'
  end
end
