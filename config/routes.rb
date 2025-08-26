Rails.application.routes.draw do
  devise_for :users

  root "patient/home#index"
  get "/supporter", to: "supporter/home#index", as: :supporter_home

  resource :settings, only: [:show]  
  resources :connections, only: [:create, :destroy]
end