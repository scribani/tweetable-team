Rails.application.routes.draw do
  root to: 'tweets#index'
  resources :tweets
  resources :users

  namespace :api do
    post '/login', to: 'sessions#create'
    post '/logout', to: 'sessions#destroy'
    resources :tweets, only: %i[index show create update destroy]
    resources :users, only: %i[show create update]
    resources :likes, only: %i[index create destroy]
  end

  # Route for Design system reference
  get '/design', to: 'designs#index'
end
