Rails.application.routes.draw do
  resources :projects
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "home#index"
  resources :dashboard, only: [:index]
  get "dashbaord/mutation_testing", to: "dashboard#mutation_testing" 
  get "dashbaord/select_mutation_operator/:model_name", to: "dashboard#select_mutation_operator", as: 'dashbaord_select_mutation_operator'
  get "dashbaord/mutation_analysis", to: "dashboard#mutation_analysis" 
  get "dashbaord/graphical_analysis", to: "dashboard#graphical_analysis" 
  get "dashbaord/graphical_analysis/:model_name", to: "dashboard#model_graphical_analysis", as: 'specific_model_graph_eval'
  get "dashbaord/selected_graphical_analysis/:model_name", to: "dashboard#selected_graphical_analysis", as: 'selected_graphical_analysis'
  get "dashbaord/selected_tabular_analysis/:model_name", to: "dashboard#selected_tabular_analysis", as: 'selected_tabular_analysis'
  get "dashbaord/tabular_analysis", to: "dashboard#tabular_analysis" 
  get "dashbaord/tabular_analysis/:model_name", to: "dashboard#model_tabular_analysis" , as: 'specific_model_table_eval'
  get "dashbaord/get_model_details/:model_name/:operator", to: "dashboard#get_model_details", as: 'dashbaord_get_model_details'
  get "dashbaord/get_layer_weights/:model_name/:operator/:layer", to: "dashboard#get_layer_weights", as: 'dashbaord_get_layer_weights'
  get "dashbaord/compare_layer_weights/:model_name/:operator/:layer", to: "dashboard#compare_layer_weights", as: 'dashbaord_compare_layer_weights'
  post "dashbaord/put_layer_weights/:model_name/:operator/:layer", to: "dashboard#put_layer_weights", as: 'dashbaord_put_layer_weights'
  post 'submit_form', to: 'home#submit_form'

  get "get_model_applicable_operator/:model_name", to: "projects#get_model_applicable_operator", as: 'get_model_applicable_operator'
  get "/projects/get_model_applicable_operator_names/:model_name/:operator", to: "projects#get_model_applicable_operator_names", as: 'get_model_applicable_operator_names'
  get '/projects/:id/select_layer', to: 'projects#select_layer', as: 'select_layer'
  get "/projects/:id/select_mutant_location/:layer", to: "projects#select_mutant_location", as: 'select_mutant_location'
  post "/projects/:id/start_mutation_testing", to: "projects#start_mutation_testing", as: 'start_mutation_testing'
end
