Rails.application.routes.draw do

  root to: 'users#show'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  # get ':username', to: 'users#show', as: 'user_path'
  resources :users, only: [:new, :create, :edit, :update, :destroy] 

  USER_RESOURCES = [:incomes, :assets, :debts, :expenses]

  USER_RESOURCES.each do |r|
    resources r, only: [:index, :new, :create, :edit, :update, :destroy]
  end

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
