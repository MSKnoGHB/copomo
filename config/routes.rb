Rails.application.routes.draw do
  devise_for :users

  namespace :public do

    root to: 'homes#top'
    get "about", to: 'homes#about'

    resources :users, only: [:show, :edit, :update]
    resources :rooms, only: [:index, :show]
    resources :room_accesses, only: [:create, :update]
    resources :chat_logs, only: [:create]
    resources :study_records
    resources :study_intervals, only: [:index, :create, :update, :destroy]
    resources :study_categories, only: [:index]
    resources :study_themes, only: [:index, :create, :edit, :update]
    resources :stamps, only: [:index]
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:create, :update, :destroy]
    resources :follows, only: [:create, :destroy]

  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
