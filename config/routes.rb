require 'sidekiq/web'

Rails.application.routes.draw do  
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  get '/oauth/callback', to: 'oauth#callback'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, only: [:index, :create]
      end
      resources :answers, only: [:show, :update, :destroy]
    end
  end
  
  get "comments/index"
  get "comments/create"
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  resources :email_confirmations, only: [:new, :create]
  get '/email_confirmations/confirm/:token', to: 'email_confirmations#confirm', as: :confirm_email

  concern :commentable do
    resources :comments, only: [:index, :create]
  end

  resources :questions do
    member do
      post :vote
    end
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :mark_as_best
        post :vote
      end
    end
    resource :subscription, only: %i[create destroy]
    concerns :commentable
  end

  resources :answers, only: [] do
    concerns :commentable
  end

  resources :users do
    resources :awards, only: %i[index]
  end

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]

  mount ActionCable.server => '/cable'

  root to: "questions#index"
end
