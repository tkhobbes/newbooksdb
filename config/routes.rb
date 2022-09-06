# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  root 'books#index'

  resources :books
  resources :settings, only: [:index]
  resources :book_formats, except: [:show] do
    get 'set_default', on: :collection
    post 'update_default', on: :collection
  end
  resources :users

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
end
