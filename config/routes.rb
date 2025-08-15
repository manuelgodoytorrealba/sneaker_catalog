# This file defines the routes for the Sneakers application.
# It includes routes for the main sneakers resource and an admin namespace.

Rails.application.routes.draw do
  devise_for :users
  resources :sneakers
  root "sneakers#index"

  namespace :admin do
    root to: "sneakers#index"
    resources :sneakers, only: [ :index, :edit, :update, :destroy ] do
      member { patch :toggle_publish }
    end
  end
end
