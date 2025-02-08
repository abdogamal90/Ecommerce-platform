Rails.application.routes.draw do

  devise_for :users

  get "sign_in", to: "devise/sessions#new"
  get "sign_up", to: "devise/registrations#new"
  delete "sign_out", to: "devise/sessions#destroy"
  
  get "carts/show"
  get "cart_items/create"
  get "cart_items/destroy"
  resources :products, only: [:index, :show]
  root "products#index"


  resources :cart_items, only: [:create, :destroy]
  resource :cart, only: [:show]
end
