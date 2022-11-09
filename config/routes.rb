Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users
  resources :services
  root 'services#index'

  get "*path", to: "application#routing_error"
end
