Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, only: %i[create]
  end

  root to: "questions#index"
end
