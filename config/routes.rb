Rails.application.routes.draw do
  namespace :public do
    get 'rooms/index'
    get 'rooms/show'
  end
  get 'chat_logs/create'
  devise_for :users
  namespace :public do
    root to: 'homes#top'
    get 'homes/about'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
