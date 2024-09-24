require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  resources :comments, :except => [:show]
  resources :posts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :auth do
    post "/register", to: "user#create"
    get "/me", to: "user#me"
    post "/login", to: "user#login"
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
