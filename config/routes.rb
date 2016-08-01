Rails.application.routes.draw do
  resources :documents
  
  resources :users do
    member do
      get :confirm_email
    end
  end

  root "home#home"

  get "/home" => "home#default"

  get '/images/show_image/:id' => "home#show_image"

  match "/404" => "errors#error404", via: [:get, :post, :patch, :delete]

  get "/signin" => "signin#signin"

  get "articles/:friendly_url/:id" => "articles#articles"

  get "/temp" => "temp#temp"

  get "/signup" => "signup#signup"

  get "/social-login/:provider" => "social_login#social"


  #temp

  post '/login-social' => 'sessions#create_session_social'

  get '/login' => 'sessions#new'

  post '/login' => 'sessions#create'

  get '/logout' => 'sessions#destroy'

  match 'auth/:provider/callback', to: 'sessions#create_social', via: [:get, :post]

  match 'auth/failure', to: redirect('/'), via: [:get, :post]

  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  


  #ADM Pages

  get '/private/index' => "private#index"

  get '/private/profiles/my-profile' => "profiles_secured#my_profile"

  get '/private/profiles/new' => "profiles_secured#new"

  get '/private/profiles/show/:profileid' => "profiles_secured#show"

  get '/private/profiles/:profileid/object/:objectid' => "object_permissions_secured#show"

  get '/private/articles/new' => "articles_secured#new"

  get '/private/articles' => "articles_secured#my_articles"

  get '/private/articles/all-articles/:numberPerPage/:pageNumber' => "articles_secured#all_articles"

  get '/private/articles/all-articles/count' => "articles_secured#count_articles"

  get '/private/articles/all-articles/count/:fieldToSearch/:searchValue' => "articles_secured#count_search_articles"

  get '/private/articles/all-articles/search/:fieldToSearch/:searchValue/:numberPerPage/:pageNumber' => "articles_secured#search_all_articles"

  get '/private/articles/show/:articleid' => "articles_secured#show"

  get '/private/articles/edit/:articleid' => "articles_secured#edit"

  get '/private/articles/destroy/:articleid' => "articles_secured#destroy"


  #POST

  post '/private/articles/create-new-article' => "articles_secured#create"

  post '/private/articles/update-article' => "articles_secured#update"

  post '/private/profiles/create-new-profile' => "profiles_secured#create"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
