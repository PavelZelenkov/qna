Rails.application.routes.draw do
  get "comments/index"
  get "comments/create"
  devise_for :users

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

  root to: "questions#index"
end
