Rails.application.routes.draw do  

  # BASIC USER NAVIGATION

  root to: 'users#show'
  get 'account', to: 'users#edit', as: "account"

  resources :users, only: [:new, :create, :update, :destroy] 
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  
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

  # FINANCE_RESOURCES = ResourceName.all.map{|r| r.table_name.to_sym}

  ResourceName.all.map{|r| r.table_name.to_sym}.each do |r|
    resources r, only: [:index, :create, :edit, :update, :destroy]
    get "#{r}/options", to: "#{r}#options"
    post "#{r}/options", to: "#{r}#process_option"
    get "#{r}/new", to: "#{r}#new_redirect"
    get "#{r}/new/:type_id", to: "#{r}#new"
    get "#{r}/index", to: "#{r}#sort_index"
    get "#{r}/:id", to: "#{r}#show"
    get "#{r}/:id/edit", to: "#{r}#edit"
  end

  # SPECIAL ASSET FORM

  5.times do |n|
    n = n+1
    get "assets/new/:asset_type_id/#{n}", to: "special_asset_form#step_#{n}", as: "special_asset_step_#{n}"
    post "assets/new/:asset_type_id/#{n}", to: "special_asset_form#process_step_#{n}", as: "process_special_asset_step_#{n}"
  end

  # FUTURE NET WORTH

  resources :future_net_worths, only: [:create]

  
  # INVALID PATH REDIRECT

  get ':invalid', to: 'sessions#invalid'
  get ':invalid/:invalid', to: 'sessions#invalid'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
