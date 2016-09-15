Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :categories, only: [:index]
  root to: 'categories#index'
  get 'categories/:internal_name', to: 'categories#show', as: :category
  get 'datasets/:internal_name', to: 'datasets#show', as: :dataset
  get 'indicators/:dataset_internal_name/:internal_name', to: 'indicators#show', as: :indicator
  get 'indicators', to: 'indicators#index', as: :indicators
  get 'series/:id', to: 'series#show', as: :series


end
