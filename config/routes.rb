Rails.application.routes.draw do
  namespace :v1 do 
    resources :users
    post "/login", to: "users#login"
    get "/auto_login", to: "users#auto_login"
    resources :account_activations, only: [:edit]
    resources :password_resets, only: [:create, :update]
  end
end
