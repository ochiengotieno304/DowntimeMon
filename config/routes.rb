Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users
  resources :services do
    resources :reports
  end
  root 'home#index'
  get 'maintenance_action/services/:id', to: 'services#maintenance_report', as: 'maintenance_action'
  get '*path', to: 'application#routing_error'
end
