# == Route Map
#

Rails.application.routes.draw do
  resources :books, only: [:show]

  # Defines the root path route ("/")
  # root "articles#index"
end
