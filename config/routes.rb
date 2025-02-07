Rails.application.routes.draw do
  get "carts/show"
  get "cart_items/create"
  get "cart_items/destroy"
  resources :products, only: [:index, :show]
  root "products#index"
  devise_for :users
  resources :cart_items, only: [:create, :destroy]
  resource :cart, only: [:show]
end
