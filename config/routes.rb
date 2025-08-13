Rails.application.routes.draw do
  resources :sneakers

  # Página de inicio → listado del catálogo
  root "sneakers#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
