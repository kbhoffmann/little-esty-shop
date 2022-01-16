Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :merchants, only: [:show] do
    resources :dashboard, only: [:index]
    resources :items, except: [:destroy]
    resources :invoices, only: [:index, :show, :update]
    resources :invoice_items, only: [:update]
    resources :discounts
  end

  namespace :admin do
    root to: 'admin#index'
    resources :merchants, only: [:index, :new, :show, :create, :edit, :update]
    resources :invoices, only: [:index, :show, :update]
  end
end
