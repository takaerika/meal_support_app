Rails.application.routes.draw do
  devise_for :users

  root "patient/home#index"
  get "/supporter", to: "supporter/home#index", as: :supporter_home

  resource :settings, only: [:show]  
  resources :connections, only: [:create, :destroy]
  resources :meal_records, only: [:index, :new, :create, :show, :edit, :update] do
     resources :comments, only: [:create, :destroy]
  end
  namespace :supporter do
  resources :patients, only: [:show]
  end
end