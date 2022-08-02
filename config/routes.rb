# frozen_string_literal: true

# == Route Map
#

Rails.application.routes.draw do
  root 'books#index'

  resources :books
  resources :settings, only: [:index]
end
