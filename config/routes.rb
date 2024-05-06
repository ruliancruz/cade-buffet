Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root to: "home#index"
  resources :payment_options, only: [:new, :create, :edit, :update, :destroy]
  resources :base_prices, only: [:edit, :update, :destroy]
  resources :orders, only: [:index, :show]

  resources :buffets, only: [:show, :new, :create, :edit, :update] do
    get 'search', on: :collection
  end

  resources :event_types, only: [:show, :new, :create, :edit, :update, :destroy] do
    resources :base_prices, only: [:new, :create]
    resources :orders, only: [:new, :create]
  end

  devise_for :buffet_owners,
    path: 'buffet_owners',
    controllers: { registrations: 'buffet_owners/registrations',
                   sessions: 'buffet_owners/sessions' }

  devise_for :clients,
    path: 'clients',
    controllers: { registrations: 'clients/registrations',
                   sessions: 'clients/sessions' }
end