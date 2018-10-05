Rails.application.routes.draw do
  root to: 'pages#home'
  get '/dashboard' => 'pages#home', as: 'dashboard'
  get '/about' => 'pages#about', as: 'about'
  get '/help' => 'pages#help', as: 'help'

  #devise_for :users
  resources :users do
    get :get, on: :collection
  end

  resource :messages, only: %i[new create]

end
