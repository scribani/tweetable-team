Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'tweets#index'

  resources :tweets
  resources :users do
    resources :likes
  end

  namespace :api do
    post '/login', to: 'sessions#create'
    post '/logout', to: 'sessions#destroy'
    resources :tweets, only: %i[index show create update destroy]
    resources :users, only: %i[show create update] do
      resources :likes, only: %i[index create destroy]
    end
  end

  get '/design', to: 'designs#index'
end
