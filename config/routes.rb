Rails.application.routes.draw do
  devise_for :users
  root 'rooms#index'
  
  resources :users, only: [:show, :edit, :update]

  resources :rooms, only: [:index, :show] do
    resources :messages, only: [:create]
  end
end