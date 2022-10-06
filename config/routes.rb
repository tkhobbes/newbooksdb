# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  root 'books#index'

  resources :books
  resources :users
  resources :authors do
    get 'remove_unused', on: :collection
  end
  resources :publishers do
    get 'remove_unused', on: :collection
  end
  resources :book_formats, except: [:show] do
    get 'set_default', on: :collection
    post 'update_default', on: :collection
  end
  resources :shelves, except: :show do
    get 'remove_unused', on: :collection
  end
  resources :genres

  resources :tags do
    get 'remove_unused', on: :collection
  end

  resources :settings, only: [:index] do
    get 'bulk_actions', on: :collection
  end

  resources :unused_items, only: [:index, :destroy]

  get 'user_destructions/new/:id', to: 'user_destructions#new', as: 'new_user_destructions'
  resources :user_destructions, only: [:create]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
end
