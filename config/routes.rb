Rails.application.routes.draw do
  resources :reports
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users
  resources :services
  root 'home#index'
  get 'maintenance_action/services/:id', to: 'services#maintenance_report', as: 'maintenance_action'
  get '*path', to: 'application#routing_error'
end
