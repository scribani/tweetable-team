Rails.application.routes.draw do
  root to: 'tweets#index'

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :tweets
  resources :users do
    resources :likes
  end

  namespace :api do
    post '/login', to: 'sessions#create'
    post '/logout', to: 'sessions#destroy'
    resources :tweets, only: %i[index show create update destroy]
    resources :users, only: %i[show create update] do
      resources :likes, only: %i[index]
    end
    resources :likes, only: %i[create destroy]
  end

  get '/design', to: 'designs#index'
end
