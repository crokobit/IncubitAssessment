Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, except: [:index, :destroy]
  resources :reset_passwords, only: [:new, :create, :edit]
  post '/do_password_reset/:id', to: 'reset_passwords#do_password_reset', as: :do_password_reset

  resources :sessions, only: [:new, :create, :destroy]
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
end
