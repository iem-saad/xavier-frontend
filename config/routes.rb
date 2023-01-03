Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "home#index"
  resources :dashboard, only: [:index]
  get "dashbaord/mutation_testing", to: "dashboard#mutation_testing" 
  get "dashbaord/get_model_details", to: "dashboard#get_model_details" 
end
