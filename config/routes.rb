Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users
  resources :services
  root 'home#index'

  get "*path", to: "application#routing_error"
end
