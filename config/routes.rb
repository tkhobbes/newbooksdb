# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  root 'books#index'

  resources :books
  resources :users
  resources :settings, only: [:index] do
    get 'bulk_actions', on: :collection
  end
  resources :book_formats, except: [:show] do
    get 'set_default', on: :collection
    post 'update_default', on: :collection
  end
  resources :shelves, except: :show do
    get 'remove_unused', on: :collection
  end
  resources :genres do
    get 'remove_unused', on: :collection
  end
  resources :tags do
    get 'remove_unused', on: :collection
  end

  get 'user_destructions/new/:id', to: 'user_destructions#new', as: 'new_user_destructions'
  resources :user_destructions, only: [:create]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
end
