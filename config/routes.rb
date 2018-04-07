Rails.application.routes.draw do  

  # BASIC USER NAVIGATION

  root to: 'users#show'
  get 'account', to: 'users#edit', as: "account"

  resources :users, only: [:new, :create, :update, :destroy] 
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: "logout"

  # INTRO QUIZ

  get "intro_quiz/1", to: 'intro_quiz#step_one', as: "iq_step_one"
  post "intro_quiz/1", to: 'intro_quiz#process_step_one', as: "iq_process_step_one"

  # STATIC PAGES

  get 'static_pages/about', as: "about"
  get 'static_pages/contact', as: "contact"

  # RESOURCE RESOURCES

  FINANCE_RESOURCES = ResourceName.all.map{|r| r.table_name.to_sym}

  FINANCE_RESOURCES.each do |r|
    resources r, only: [:index, :create, :edit, :update, :destroy]
    get "#{r}/options", to: "#{r}#options"
    post "#{r}/options", to: "#{r}#process_option"
    get "#{r}/new", to: "#{r}#new_redirect"
    get "#{r}/new/:type_id", to: "#{r}#new"
    get "#{r}/:id", to: "#{r}#show"
  end

  # SPECIAL ASSET FORM

  5.times do |n|
    n = n+1
    get "assets/new/:asset_type_id/#{n}", to: "special_asset_form#step_#{n}", as: "special_asset_step_#{n}"
    post "assets/new/:asset_type_id/#{n}", to: "special_asset_form#process_step_#{n}", as: "process_special_asset_step_#{n}"
  end

  # get "assets/new/:special_asset/1", to: "special_asset_form#step_one", as: "step_one"
  # post "assets/new/:special_asset/1", to: "special_asset_form#process_step_one", as: "process_step_one"
  # get "assets/new/:special_asset/2", to: "special_asset_form#step_two", as: "step_two"
  # post "assets/new/:special_asset/2", to: "special_asset_form#process_step_two", as: "process_step_two"
  # get "assets/new/:special_asset/3", to: "special_asset_form#step_three", as: "step_three"
  # post "assets/new/:special_asset/3", to: "special_asset_form#process_step_three", as: "process_step_three"
  # get "assets/new/:special_asset/4", to: "special_asset_form#step_four", as: "step_four"
  # post "assets/new/:special_asset/4", to: "special_asset_form#process_step_four", as: "process_step_four"
  # get "assets/new/:special_asset/5", to: "special_asset_form#step_five", as: "step_five"
  # post "assets/new/:special_asset/5", to: "special_asset_form#process_step_five", as: "process_step_five"

  # FUTURE NET WORTH

  resources :future_net_worths, only: [:create]

  
  # INVALID PATH REDIRECT

  get ':invalid', to: 'sessions#invalid'
  get ':invalid/:invalid', to: 'sessions#invalid'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
