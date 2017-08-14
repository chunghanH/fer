Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :lists
  resources :currencies, only: [:index, :create, :destroy]
  root 'lists#index'
  get '/about' => 'lists#about'
end
