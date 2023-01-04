Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "home#index"
  resources :dashboard, only: [:index]
  get "dashbaord/mutation_testing", to: "dashboard#mutation_testing" 
  get "dashbaord/select_mutation_operator/:model_name", to: "dashboard#select_mutation_operator", as: 'dashbaord_select_mutation_operator'
  get "dashbaord/mutation_analysis", to: "dashboard#mutation_analysis" 
  get "dashbaord/get_model_details/:model_name/:operator", to: "dashboard#get_model_details", as: 'dashbaord_get_model_details' 
end
