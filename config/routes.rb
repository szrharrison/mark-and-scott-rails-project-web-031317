Rails.application.routes.draw do

  get '/', to: 'pictures#index', as: :root

  resources :users, except: :index
  resources :pictures
  resources :categories

  post '/picture-categories', to: 'picture_categories#create', as: :create_picture_category
  delete '/picture-categories/:id', to: 'picture_categories#destroy', as: :destroy_picture_category
  get '/login', to: 'sessions#new', as: :login
  post '/sessions', to: 'sessions#create', as: :create_session
  delete '/sessions/:id', to: 'sessions#destroy', as: :destroy_session
end