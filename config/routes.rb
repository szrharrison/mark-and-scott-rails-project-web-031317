Rails.application.routes.draw do

  get '/', to: 'pictures#index', as: :root

  resources :users, except: :index

  resources :pictures
  post 'pictures/:id/black_and_white', to: 'pictures#black_and_white', as: :bw
  post 'pictures/:id/edge', to: 'pictures#edge', as: :edge
  post 'pictures/:id/sepia', to: 'pictures#sepia', as: :sepia
  post 'pictures/:id/charcoal', to: 'pictures#charcoal', as: :charcoal
  post 'pictures/:id/sketch', to: 'pictures#sketch', as: :sketch
  post 'pictures/:id/vignette', to: 'pictures#vignette', as: :vignette
  post 'pictures/:id/polaroid', to: 'pictures#polaroid', as: :polaroid
  post 'pictures/:id/make_bigger', to: 'pictures#make_bigger', as: :make_bigger
  post 'pictures/:id/make_smaller', to: 'pictures#make_smaller', as: :make_smaller
  post 'pictures/:id/make_thumbnail', to: 'pictures#make_thumbnail', as: :make_thumbnail
  post 'pictures/:id/flip_vertical', to: 'pictures#flip_vertical', as: :flip_vertical
  post 'pictures/:id/flip_horizontal', to: 'pictures#flip_horizontal', as: :flip_horizontal




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
