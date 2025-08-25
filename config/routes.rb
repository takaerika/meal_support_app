Rails.application.routes.draw do
  get 'connections/create'
  devise_for :users

  # 既存
  root "patient/home#index"

  # サポーター用の簡易トップ
  get "/supporter", to: "supporter/home#index", as: :supporter_home

  resources :connections, only: :create  # POST /connections
end