Rails.application.routes.draw do

  devise_for :users
  devise_for :admins, controllers: {sessions: "admin/devise/sessions"}

  namespace :admin do

    root to: "dashboards#index"
    resources :users, only: [:index, :destroy]
    resources :study_records, only: [:index, :destroy]
    resources :comments, only: [:index, :destroy]

    resources :rooms, only: [:index, :show] do
      resources :chat_logs, only: [:destroy]
    end

    resources :room_accesses, only: [] do
      member do
        patch :force_exit
      end
    end

    resources :study_categories, only: [:create, :edit, :index, :update] do
      member do
        patch :activate
      end
    end

    resources :stamps, only: [:create, :edit, :index, :update] do
      member do
        patch :activate
      end
    end

  end

  namespace :public do
    root to: 'homes#top'
    get "about", to: 'homes#about'

    resources :users, only: [:show, :edit, :update, :destroy] do 
      resources :study_records, only: [:index] 
      resources :study_themes, only: [:index]
    end

    resources :rooms, only: [:index, :show] do
      member do 
        get :check_timer
      end
    end
    
    resources :room_accesses, only: [:create, :update] do
      collection do
        patch :status_change
      end
    end

    resources :chat_logs, only: [:create]
    
    resources :study_records do
      resources :comments, only: [:create, :destroy]
      resource :likes, only: [:create, :destroy]
      member do 
        patch :finish
        patch :post
      end
    end

    resources :study_intervals, only: [:index, :create, :update, :destroy] do
      collection do
        post :auto_paused
      end
    end

    resources :study_categories, only: [:index]
    resources :study_themes, only: [:index,:create, :edit, :update, :destroy]
    resources :stamps, only: [:index]
    resources :follows, only: [:create, :destroy]

    devise_scope :user do
      post "guest_sign_in", to: "guest_logins#guest_sign_in"
    end

  end


  get '/search', to: 'searches#search'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
