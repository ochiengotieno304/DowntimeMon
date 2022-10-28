Rails.application.routes.draw do
  devise_for :users
  resources :services
  root 'services#index'
end
