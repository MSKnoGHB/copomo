Rails.application.routes.draw do
  namespace :public do
    get 'follows/create'
    get 'follows/destroy'
  end
  namespace :public do
    get 'comments/create'
    get 'comments/update'
    get 'comments/destroy'
  end
  namespace :public do
    get 'likes/create'
    get 'likes/destroy'
  end
  namespace :public do
    get 'stamps/index'
  end
  namespace :public do
    get 'study_themes/index'
    get 'study_themes/create'
    get 'study_themes/edit'
    get 'study_themes/update'
  end
  namespace :public do
    get 'study_categories/index'
  end
  namespace :public do
    get 'study_intervals/index'
    get 'study_intervals/create'
    get 'study_intervals/update'
    get 'study_intervals/destroy'
  end
  namespace :public do
    get 'study_records/index'
    get 'study_records/show'
    get 'study_records/create'
    get 'study_records/edit'
    get 'study_records/update'
    get 'study_records/destroy'
  end
  namespace :public do
    get 'chat_logs/create'
  end
  namespace :public do
    get 'room_accesses/create'
    get 'room_accesses/update'
  end
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
