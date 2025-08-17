Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :mark_as_best
      end
    end
  end

  resources :users do
    resources :awards, only: %i[index]
  end

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]

  root to: "questions#index"
end
