require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users

  resources :stocks, only: %w[show]

  namespace :admin do
    root to: "users#index"

    resources :users
    resources :stock_exchanges
    resources :sectors
    resources :stocks
    resources :wallets
    resources :fiis, controller: :stocks
    resources :etfs, controller: :stocks
  end
end
