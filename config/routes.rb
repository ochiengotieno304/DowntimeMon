Rails.application.routes.draw do
  resources :services
  root 'home#index'
end
