Rails.application.routes.draw do
  resources :users
  resources :pictures
  resources :categories

  post '/picture-categories', to: 'picture_categories#create', as: :create_picture_category
end
