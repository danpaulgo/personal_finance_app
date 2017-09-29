Rails.application.routes.draw do

  root to: 'users#show'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # get ':username', to: 'users#show', as: 'user_path'
  resources :users, only: [:new, :create, :edit, :update, :destroy] 

  # FINANCE_RESOURCES = [:incomes, :liquid_assets, :non_liquid_assets, :debts, :expenses]
  # FINANCE_RESOURCES = ResourceName.all.map{|r| r.name.downcase.gsub(/([\-\(\s])/, "_").gsub(")", "").pluralize.to_sym}
  FINANCE_RESOURCES = ResourceName.all.map{|r| r.table_name.to_sym}

  FINANCE_RESOURCES.each do |r|
    resources r, only: [:index, :create, :edit, :update, :destroy]
    get "#{r}/options", to: "#{r}#options"
    get "#{r}/new/:type", to: "#{r}#new"
  end

  post "assets/new/vehicle", to: "vehicle_form#process_vehicle_step_one", as: "process_vehicle_step_one"
  get "assets/new/vehicle/2", to: "vehicle_form#vehicle_step_two", as: "vehicle_step_two"
  post "assets/new/vehicle/2", to: "vehicle_form#process_vehicle_step_two", as: "process_vehicle_step_two"
  get "assets/new/vehicle/3", to: "vehicle_form#vehicle_step_three", as: "vehicle_step_three"
  post "assets/new/vehicle/3", to: "vehicle_form#process_vehicle_step_three", as: "process_vehicle_step_three"
  get "assets/new/vehicle/4", to: "vehicle_form#vehicle_step_four", as: "vehicle_step_four"
  post "assets/new/vehicle/4", to: "vehicle_form#process_vehicle_step_four", as: "process_vehicle_step_four"
  get "assets/new/vehicle/5", to: "vehicle_form#vehicle_step_five", as: "vehicle_step_five"
  post "assets/new/vehicle/5", to: "vehicle_form#process_vehicle_step_five", as: "process_vehicle_step_five"
  # get "assets/new/vehicle/complete", to: "vehicle_form#process_vehicle_form", as: "process_vehicle_form"

  resources :future_net_worths, only: [:create]

  # Redirects invalid urls to root path
  get ':invalid', to: 'sessions#invalid'
  get ':invalid/:invalid', to: 'sessions#invalid'

  # resources :expenses, only: [:index, :new, :create, :edit, :update, :delete]
  # get 'users/:id/incomes', to: 'users#incomes', as: :incomes
  # get 'users/:id/assets', to: 'users#assets', as: :assets
  # get 'users/:id/credits', to: 'users#credits', as: :credits
  # get 'users/:id/debts', to: 'users#debts', as: :total_liabilities
  # get 'users/:id/expenses', to: 'users#expenses', as: :expenses
  # get 'users/:id/net_worth', to: 'users#net_worth', as: :net_worth
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
