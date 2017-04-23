Rails.application.routes.draw do

  get '/', to: 'pictures#index', as: :root

  resources :users, except: :index
  resources :pictures
  resources :categories
  resources :tags

  # Picture Categories
  post '/picture-categories', to: 'picture_categories#create', as: :create_picture_category
  delete 'pictures/:picture_id/picture-categories/:id', to: 'picture_categories#destroy', as: :destroy_picture_category

  # Picture Tags
  delete '/pictures/:picture_id/picture-tags/:id', to: 'picture_tags#destroy', as: :destroy_picture_tag

  # Following Users
  post '/user-leaders/:leader_id', to: 'user_leaders#create', as: :create_user_leader

  # Favorites
  post '/users/:user_id/favorites/:picture_id', to: 'favorites#create', as: :create_favorite
  delete '/users/:user_id/favorites/:id', to: 'favorites#destroy', as: :destroy_favorite

  # Session
  get '/login', to: 'sessions#new', as: :login
  post '/sessions', to: 'sessions#create', as: :create_session
  delete '/sessions/:id', to: 'sessions#destroy', as: :destroy_session

end
