Rails.application.routes.draw do

  devise_for :admin

  # Concerns ======================================

  concern :positionable do
    patch :position, on: :member
  end

  # Admin ======================================

  namespace :admin do
    resources :admins
    resources :basic_pages, concerns: :positionable
    resources :themes, concerns: :positionable
    resources :axes, concerns: :positionable
    resources :tags, concerns: :positionable
    resources :tool_categories, concerns: :positionable
    resources :tools do
      member do
        patch :accept 
        patch :reject
      end
      # resources :tool_attachments, as: :attachments, controller: "tools/attachments"
    end
    resources :tool_attachments
    resources :seos, only: [:index, :edit, :update]
    root to: 'dashboard#index'
  end

  # Front ======================================
  
  resources :basic_pages, only: [:show]
  put "/accept_cookies", to: "home#accept_cookies"
  get "/:filename", to: "statics#show"

  root to: 'home#index'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
