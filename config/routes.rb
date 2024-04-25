Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root to: "home#index"
  resources :buffets, only: [:show, :new, :create, :edit, :update]
  resources :payment_options, only: [:new, :create, :edit, :update, :destroy]
  resources :base_prices, only: [:destroy]

  resources :event_types, only: [:show, :new, :create, :edit, :update, :destroy] do
    resources :base_prices, only: [:new, :create]
  end

  devise_for :buffet_owners, path: 'buffet_owners',
    controllers: { registrations: 'buffet_owners/registrations' }
end