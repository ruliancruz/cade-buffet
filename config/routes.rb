Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root to: "home#index"
  devise_for :buffet_owners, path: 'buffet_owners'
end
