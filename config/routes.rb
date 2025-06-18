Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users , controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  resources :users, only: [ :index, :edit, :update, :destroy, :create, :new ]
  get "checkout/show"
  get "checkout/create"

  get "carts/show"
  get "cart_items/create"
  get "cart_items/destroy"
  resources :products, only: [ :index, :show ]
  resources :wishlist_items, only: [ :index, :create, :destroy ] do
    collection do
      delete :delete
    end
  end
  root "products#index"

  get 'profile', to: 'profiles#show'


  resources :cart_items, only: [ :create, :destroy ]
  resource :cart, only: [:show]
  resources :orders, only: [:index, :show, :create]
  resource :checkout, only: [:show, :create]

  post '/webhooks/stripe', to: 'webhooks#stripe'
  get '/checkout/success', to: 'checkouts#success'
  get '/checkout/cancel', to: 'checkouts#cancel'
end
