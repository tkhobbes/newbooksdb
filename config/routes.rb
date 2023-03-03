# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  root 'home#index'

  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
  end

  devise_for :owners, controllers: {
    registrations: 'owners/registrations'
  }
  get 'owners/:id', to: 'owners#show', as: 'owner'
  resources :profiles, only: %i[index show edit update]

  resources :books
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

  # the whole service logic
  get 'isbn_search/new', to: 'isbn_search#new'
  post 'isbn_search/show', to: 'isbn_search#show'
  post 'isbn_create/create', to: 'isbn_create#create'
  post 'cover_search/create', to: 'cover_search#create'
  get 'scan/new', to: 'scan#new'
  resources :scan_queues, only: %i[index show new create destroy]
end
