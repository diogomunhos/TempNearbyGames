Rails.application.routes.draw do
  match "*path" => redirect("http://www.wahiga.com/%{path}"), :constraints => { :protocol => "https://" }
  
  resources :companies, defaults: { format: 'json' }
  resources :social_medias, defaults: { format: 'json' }
  resources :games, defaults: { format: 'json' }
  resources :game_companies
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

  get '/sitemap.xml', to: redirect("https://wahiga.s3-sa-east-1.amazonaws.com/sitemaps/sitemap.xml.gz", status: 301)

  get '/Sitemap.xml', to: redirect("https://wahiga.s3-sa-east-1.amazonaws.com/sitemaps/sitemap.xml.gz", status: 301)

  get "/home" => "home#default", :status => 301

  get "/Robots.txt", to: redirect("https://www.wahiga.com/robots.txt", status: 301)

  get '/images/:id' => "home#show_image"  

  get '/images/:id/:image_name' => "home#show_image"

  match "/404" => "errors#error404", via: [:get, :post, :patch, :delete]

  get "/signin" => "signin#signin"

  get "/article/:friendly_url" => "articles#show"

  get "/News/:friendly_url" => "articles#show"

  get "/news/:friendly_url" => "articles#show"

  get "/:game_or_movie/news/:friendly_url" => "articles#show"

  get '/news/:author_name/:author_id' => "articles#all_articles"

  get '/news' => "articles#all_articles"

  get '/all-articles', to: redirect("/news", status: 301)

  get '/all-articles/get-articles-from-page/:numberPerPage/:pageNumber' => "articles#get_articles_service"

  get "/temp" => "temp#temp"

  get "/signup" => "signup#signup"

  post "/signup-service" => "users#create_user_service"

  get "/social-login/:provider" => "social_login#social"

  get "/platform/:platform" => "articles#platform"

  get "/:platform/get-articles-paged/:numberPerPage/:pageNumber" => "articles#get_platform_articles_service"

  get "/:game" => "games#show"

  get "/:game/news" => "games#news"

  get "/:game/images" => "games#images"

  get '/forgot-password' => "forgot_password#forgot_password"

  post '/send-confirmation-email.json' => "users#resend_confirmation_email"

  get "/email-confirmed" => "users#email_confirmed"

  get "/user/:userid/profile" => "users#profile"

  post "/submit-comment-to-article" => "articles#submit_comment"


  #temp

  post '/login-social' => 'sessions#create_session_social'

  post '/login-social-service' => 'sessions#create_session_social_service'

  get '/login' => 'sessions#new'

  post '/login' => 'sessions#create'

  get '/logout' => 'sessions#destroy'

  post '/login-service' => "sessions#create_service"

  match 'auth/:provider/callback', to: 'sessions#create_social', via: [:get, :post]

  match 'auth/failure', to: redirect('/'), via: [:get, :post]

  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  get '/private/unauthorized' => "private#unauthorized_401" 


  #ADM Pages

  #INDEX
  get '/private/index' => "private#index"

  get '/private/index/get-permissions' => "private#get_permissions_service"
  
  #PROFILES

  get '/private/profiles/refresh_profiles' => "profiles_secured#refresh_profiles"

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

  get '/private/articles/update_image_performance/:offset/:limit' => "articles_secured#update_image_performance"


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

  #Companies
 
  get '/private/companies' => "companies_secured#all_companies"
 
  get '/private/companies/:companyid/show' => "companies_secured#show"
 
  get '/private/companies/:companyid/edit' => "companies_secured#edit"
 
  get '/private/companies/new' => "companies_secured#new"
 
  get '/private/companies/all-companies/:numberPerPage/:pageNumber' => "companies_secured#all_companies_service"
 
  get '/private/companies/all-companies/count' => "companies_secured#count_all_companies_service"
 
  post '/private/companies/update' => "companies_secured#update"
 
  post '/private/companies/create-new-company' => "companies_secured#create"
 
  get '/private/companies/destroy/:companyid' => "companies_secured#destroy"

  # Social Article

  get '/private/social-articles/:articleId/new' => "social_articles_secured#new"

  post '/private/social-articles/create_social_article_service' => "social_articles_secured#create_social_article_service"


   #Social Media
 
  get '/private/social-medias' => "social_medias_secured#all_social_medias"
 
  get '/private/social-medias/:socialMediaid/show' => "social_medias_secured#show"
 
  get '/private/social-medias/:socialMediaid/edit' => "social_medias_secured#edit"
 
  get '/private/social-medias/new' => "social_medias_secured#new"
 
  get '/private/social-medias/all-social-medias/:numberPerPage/:pageNumber' => "social_medias_secured#all_social_medias_service"
 
  get '/private/social-medias/all-social-medias/count' => "social_medias_secured#count_all_social_medias_service"
 
  post '/private/social-medias/update' => "social_medias_secured#update"
 
  post '/private/social-medias/create-new-social-media' => "social_medias_secured#create"
 
  get '/private/social-medias/destroy/:socialMediaid' => "social_medias_secured#destroy"
 
 
   #Games
 
   get '/private/games/new' => "games_secured#new"
 
   get '/private/games' => "games_secured#my_games"
 
   get '/private/games/all-games/:numberPerPage/:pageNumber' => "games_secured#all_games"
 
   get '/private/games/all-games/count' => "games_secured#count_games"
 
   get '/private/games/all-games/count/:fieldToSearch/:searchValue' => "games_secured#count_search_games"
 
   get '/private/games/all-games/search/:fieldToSearch/:searchValue/:numberPerPage/:pageNumber' => "games_secured#search_all_games"
 
   get '/private/games/show/:gameid' => "games_secured#show"
 
   get '/private/games/edit/:gameid' => "games_secured#edit"
 
   get '/private/games/destroy/:gameid' => "games_secured#destroy"
 
   #POST
   #Games
   post '/private/games/create-new-games' => "games_secured#create"
 
   post '/private/games/update-game' => "games_secured#update"
 
   post '/private/games/create_game_service' => "games_secured#create_game_service"
 
   post '/private/games/update_game_service' => "games_secured#update_game_service"
 
   post '/private/games/create_game_companies_service' => "games_secured#create_game_companies_service"
 
   post '/private/games/destroy_game_company_service' => "games_secured#destroy_game_company_service"
 
   post '/private/games/upload_game_image_service' => "games_secured#upload_game_image_service"


  #Cinema
 
   get '/private/cinemas/new' => "cinemas_secured#new"
 
   get '/private/cinemas' => "cinemas_secured#my_cinemas"
 
   get '/private/cinemas/all-cinemas/:numberPerPage/:pageNumber' => "cinemas_secured#all_cinemas"
 
   get '/private/cinemas/all-cinemas/count' => "cinemas_secured#count_cinemas"
 
   get '/private/cinemas/all-cinemas/count/:fieldToSearch/:searchValue' => "cinemas_secured#count_search_cinemas"
 
   get '/private/cinemas/all-cinemas/search/:fieldToSearch/:searchValue/:numberPerPage/:pageNumber' => "cinemas_secured#search_all_cinemas"
 
   get '/private/cinemas/show/:cinemaid' => "cinemas_secured#show"
 
   get '/private/cinemas/edit/:cinemaid' => "cinemas_secured#edit"
 
   get '/private/cinemas/destroy/:cinemaid' => "cinemas_secured#destroy"
 
   #POST
   #Cinema
   post '/private/cinemas/create-new-cinema' => "cinemas_secured#create"
 
   post '/private/cinemas/update-cinema' => "cinemas_secured#update"
 
   post '/private/cinemas/create_cinema_service' => "cinemas_secured#create_cinema_service"
 
   post '/private/cinemas/update_cinema_service' => "cinemas_secured#update_cinema_service"
 
   post '/private/cinemas/create_cinema_companies_service' => "cinemas_secured#create_cinema_companies_service"
 
   post '/private/cinemas/destroy_cinema_company_service' => "cinemas_secured#destroy_cinema_company_service"
 
   post '/private/cinemas/upload_cinema_image_service' => "cinemas_secured#upload_cinema_image_service"






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
