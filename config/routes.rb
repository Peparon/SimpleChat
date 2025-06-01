Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users
  root 'homes#top'
  get 'home', to: 'homes#home'
  get 'friendships/search', to: 'friendships#search', as: 'search_friend'

  resources :users, only: [:index, :show, :edit, :update]
  resources :friendships, only: [:search, :index, :create]
  resources :rooms, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end
end