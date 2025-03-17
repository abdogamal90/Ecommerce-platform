Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :edit, :update, :destroy]
  get "checkout/show"
  get "checkout/create"

  
  get "carts/show"
  get "cart_items/create"
  get "cart_items/destroy"
  resources :products, only: [:index, :show]
  resources :wishlist_items, only: [:create, :destroy, :show, :index]
  root "products#index"


  resources :cart_items, only: [:create, :destroy]
  resource :cart, only: [:show]
  resources :orders, only: [:index, :show, :create]
  resource :checkout, only: [:show, :create]

  post '/webhooks/stripe', to: 'webhooks#stripe'
  get '/checkout/success', to: 'checkouts#success'
  get '/checkout/cancel', to: 'checkouts#cancel'
  
end
