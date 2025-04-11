Rails.application.routes.draw do
  devise_for :users
  root 'homes#top'
  get 'home', to: 'homes#home'

  resources :users, only: [:index, :show, :edit, :update]
  resources :friendships, only: [:create, :update, :destroy]
  resources :rooms, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end
end