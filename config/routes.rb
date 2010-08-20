Urlsplease::Application.routes.draw do |map|
  
  resources :tags
  
  match 'requests/tagged(/:search_string)', 
    :to => 'requests#tag_search',
    :as => 'requests_tagged'
  # match 'requests/tagged', :to => 'requests#tag_search'          # For POST
  
  resources :resources   
  
  resources :requests
  
  devise_for :users, :path => 'accounts'
  
  resources :users do
    resources :resources
    resources :requests do       
      resources :resources
    end
    resources :tag_subscriptions
  end
  
  resources :profiles
  
  get "welcome/index"
  get "welcome/purpose"
  get "welcome/todo"
  get "welcome/releasenotes"
  
  root :to => "welcome#index"
  
end
