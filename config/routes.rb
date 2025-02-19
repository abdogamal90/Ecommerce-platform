Rails.application.routes.draw do
  get "checkout/show"
  get "checkout/create"

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
  resources :orders, only: [:index, :show, :create]
  resource :checkout, only: [:show, :create]

  post '/webhooks/stripe', to: 'webhooks#stripe'
  get '/checkout/success', to: 'checkouts#success'
  get '/checkout/cancel', to: 'checkouts#cancel'
  
end
