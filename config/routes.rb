Rails.application.routes.draw do
  devise_for :users
  root 'rooms#index'
  
  resources :users, only: [:show, :edit, :update] do
    resources :rooms, only: [:show, :create]
  end

  resources :rooms, only: [:index] do
    resources :messages, only: [:create]
  end
  
end