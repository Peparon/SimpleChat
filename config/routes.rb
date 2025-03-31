Rails.application.routes.draw do
  devise_for :users
  root 'rooms#index'

  resources :rooms, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end
  resources :users, only: [:show]
end