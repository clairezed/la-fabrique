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
    resources :trainings
    resources :training_tools, only: [:destroy], concerns: :positionable
    resources :comments, only: [:index, :destroy] do
      member do
        patch :accept 
        patch :reject
      end
    end
    resources :tools do
      member do
        patch :accept 
        patch :reject
        get :edit_part_1
        put :part_1
        get :edit_part_2
        put :part_2
      end
      resources :steps, controller: "tools/steps", only: [:destroy]
      resources :tool_attachments, as: :attachments, controller: "tools/tool_attachments"
      resources :links, controller: "tools/links"
    end
    resources :seos, only: [:index, :edit, :update]
    root to: 'dashboard#index'
  end

  # Front ======================================
  
  resources :axes, only: [:index]
  resources :tools, only: [:index, :show, :new, :create, :update] do
    member do
      get :edit_part_1
      put :part_1
      get :edit_part_2
      put :part_2
      get :submission_success
    end
    resources :comments, controller: "tools/comments", only: [:create]
    resources :steps, controller: "tools/steps", only: [:destroy]
    resources :tool_attachments, as: :attachments, controller: "tools/tool_attachments"
    resources :links, controller: "tools/links"
  end
  resources :tags, only: [:index]
  resources :basic_pages, only: [:show]
  put "/accept_cookies", to: "home#accept_cookies"
  get "/:filename", to: "statics#show"

  root to: 'axes#index'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
