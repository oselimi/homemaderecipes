Rails.application.routes.draw do
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  root to: 'recipes#index'
  get 'signup', to: 'users#new'

  resources :users, except: :new
  resources :recipes do
    resources :instructions
    resources :ingredients
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
