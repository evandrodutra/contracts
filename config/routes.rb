Rails.application.routes.draw do
  resources :users, only: [:create]
  resources :contracts, only: [:show, :create, :destroy]
end
