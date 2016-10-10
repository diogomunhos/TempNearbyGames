Rails.application.routes.draw do
  resources :articles, defaults: { format: 'json' }
  resources :documents
  resources :user_login_info_secured do 
    member do 
      get :reset_password
    end
  end
  resources :users do
    member do
      get :confirm_email
    end
  end


  root "home#home"

  get "/home" => "home#default"

  get '/images/show_image/:id' => "home#show_image"

  get '/images/show_image/:id/:image_name' => "home#show_image"

  match "/404" => "errors#error404", via: [:get, :post, :patch, :delete]

  get "/signin" => "signin#signin"

  get "/article/:friendly_url" => "articles#show"

  get "/News/:friendly_url" => "articles#show"

  get '/all-articles/:author_name/:author_id' => "articles#all_articles"

  get '/all-articles' => "articles#all_articles"

  get "/temp" => "temp#temp"

  get "/signup" => "signup#signup"

  get "/social-login/:provider" => "social_login#social"

  get "/platform/:platform" => "articles#platform"


  #temp

  post '/login-social' => 'sessions#create_session_social'

  get '/login' => 'sessions#new'

  post '/login' => 'sessions#create'

  get '/logout' => 'sessions#destroy'

  match 'auth/:provider/callback', to: 'sessions#create_social', via: [:get, :post]

  match 'auth/failure', to: redirect('/'), via: [:get, :post]

  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  get '/private/unauthorized' => "private#unauthorized_401" 


  #ADM Pages

  #INDEX
  get '/private/index' => "private#index"

  get '/private/index/get-permissions' => "private#get_permissions_service"
  
  #PROFILES
  get '/private/profiles/my-profile' => "profiles_secured#my_profile"

  get '/private/profiles/user-profile/:userid' => "profiles_secured#user_profile"

  get '/private/profiles/my-profile/edit' => "profiles_secured#my_profile_edit"

  get '/private/profiles/new' => "profiles_secured#new"

  get '/private/profiles/show/:profileid' => "profiles_secured#show"

  get 'private/profiles' => "profiles_secured#all_profiles"

  get '/private/profiles/all-profiles/:numberPerPage/:pageNumber' => "profiles_secured#all_profiles_service"

  get '/private/profiles/all-profiles/count' => "profiles_secured#count_all_profiles_service"

  get '/private/profiles/:profileid/destroy' => "profiles_secured#destroy"

  get '/private/profiles/:profileid/activate' => "profiles_secured#activate"

  get '/private/profiles/:profileid/deactivate' => "profiles_secured#deactivate"

  
  #Objects
  get '/private/profiles/:profileid/object/:objectid/edit' => "object_permissions_secured#edit"
  
  get '/private/profiles/:profileid/object/:objectid' => "object_permissions_secured#show"

  #Articles
  get '/private/articles/new' => "articles_secured#new"

  get '/private/articles' => "articles_secured#my_articles"

  get '/private/articles/all-articles/:numberPerPage/:pageNumber' => "articles_secured#all_articles"

  get '/private/articles/all-articles/count' => "articles_secured#count_articles"

  get '/private/articles/all-articles/count/:fieldToSearch/:searchValue' => "articles_secured#count_search_articles"

  get '/private/articles/all-articles/search/:fieldToSearch/:searchValue/:numberPerPage/:pageNumber' => "articles_secured#search_all_articles"

  get '/private/articles/show/:articleid' => "articles_secured#show"

  get '/private/articles/edit/:articleid' => "articles_secured#edit"

  get '/private/articles/destroy/:articleid' => "articles_secured#destroy"

  get '/private/articles/approve/:articleid' => "articles_secured#approve"

  get '/private/articles/reject/:articleid' => "articles_secured#reject"

  get '/private/articles/publish/:articleid' => "articles_secured#publish" 

  get '/private/articles/send_to_approval/:articleid' => "articles_secured#send_to_approval"


  #Users

  get '/private/users' => "users_secured#all_users"

  get '/private/users/:userid/show' => "users_secured#show"

  get '/private/users/:userid/edit' => "users_secured#edit"

  get '/private/users/new' => "users_secured#new"

  get '/private/users/all-users/:numberPerPage/:pageNumber' => "users_secured#all_users_service"

  get '/private/users/all-users/count' => "users_secured#count_all_users_service"

  # get 'acceptInvitation/:confirm_token/password-change-secur/:password_token' => 'users_secured#confirm_email_set_password'

  #User Login Info

  get '/private/users/:userid/reset-password' => "user_login_infos_secured#create"

  #User Invitation

  get '/private/change-password-invitation' => "user_invitations_secured#change_password"

  get '/private/accept-invitation/:confirmToken/change-password/:resetPasswordToken' => "user_invitations_secured#confirm_invitation"


  #POST
  #Articles
  post '/private/articles/create-new-article' => "articles_secured#create"

  post '/private/articles/update-article' => "articles_secured#update"

  post '/private/articles/create_article_service' => "articles_secured#create_article_service"

  post '/private/articles/update_article_service' => "articles_secured#update_article_service"

  post '/private/articles/upload_files_service' => "articles_secured#upload_files_service"

  post '/private/articles/delete_file_service' => "articles_secured#delete_file_service"

  post '/private/articles/update_article_facebook_post_id_service' => "articles_secured#update_article_facebook_post_id_service"
  # Profiles
  post '/private/profiles/create-new-profile' => "profiles_secured#create"

  post '/private/profiles/my-profile/save' => "profiles_secured#save_service"

  post '/private/profiles/my-profile/upload_profile_image_service' => "profiles_secured#upload_profile_image_service"
  #Objects

  post '/private/profiles/objects/update-object' => "object_permissions_secured#update"

  #User

  post '/private/users/update' => "users_secured#update"

  post '/private/users/create-new-user' => "users_secured#create"

  #User Invitation

  post '/private/update-password' => "user_invitations_secured#update"



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
