# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  devise_for :owners
  root 'books#index'

  resources :books
  resources :users
  resources :authors
  resources :publishers
  resources :book_formats, except: [:show] do
    get 'set_default', on: :collection
    post 'update_default', on: :collection
  end
  resources :shelves, except: :show
  resources :genres
  resources :tags

  resources :settings, only: [:index] do
    get 'bulk_actions', on: :collection
  end

  # Functional controllers without models
  resources :unused_items, only: [:index, :destroy]

  resources :search, only: [:index]
  get 'quicksearch', to: 'search#quicksearch'

  resources :user_destructions, only: [:create]
  get 'user_destructions/new/:id', to: 'user_destructions#new', as: 'new_user_destructions'

  # Session & user authentication stuff
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
end
