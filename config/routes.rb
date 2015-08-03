Rails.application.routes.draw do
	get "/users/:user_id/articles", to: "users#index", as: "user_articles"
  get '/articles/compare', to: "articles#compare", as: "compare"

  get '/articles/crawl', to: "articles#crawl", as: "crawl"
  resources :users do
    resources :articles, shallow: true
  end

 	resources :resets, only: [:new, :create]

	root "articles#index"
	get '/articles', to: "articles#index"


	get '/about', to: "static#about", as: "about"

	get '/resets/:token', to: "resets#edit", as: "reset"
	patch '/resets/:token', to: "resets#update"

	get 'login', to: "sessions#login", as: "login"
	post 'login', to: "sessions#attempt_login"

	get '/signup', to: "sessions#signup", as: 'signup'
	post '/signup', to: "sessions#create"

	delete 'logout', to: "sessions#logout", as: "logout"
 
# 	 user_articles GET    /users/:user_id/articles(.:format)     articles#index
#                  POST   /users/:user_id/articles(.:format)     articles#create
# new_user_article GET    /users/:user_id/articles/new(.:format) articles#new
#     edit_article GET    /articles/:id/edit(.:format)           articles#edit
#          article GET    /articles/:id(.:format)                articles#show
#                  PATCH  /articles/:id(.:format)                articles#update
#                  PUT    /articles/:id(.:format)                articles#update
#                  DELETE /articles/:id(.:format)                articles#destroy
#            users GET    /users(.:format)                       users#index
#                  POST   /users(.:format)                       users#create
#         new_user GET    /users/new(.:format)                   users#new
#        edit_user GET    /users/:id/edit(.:format)              users#edit
#             user GET    /users/:id(.:format)                   users#show
#                  PATCH  /users/:id(.:format)                   users#update
#                  PUT    /users/:id(.:format)                   users#update
#                  DELETE /users/:id(.:format)                   users#destroy
#           resets POST   /resets(.:format)                      resets#create
#        new_reset GET    /resets/new(.:format)                  resets#new
#             root GET    /                                      articles#index
#         articles GET    /articles(.:format)                    articles#index
# articles_compare GET    /articles/compare(.:format)            articles#compare
#            reset GET    /resets/:token(.:format)               resets#edit
#                  PATCH  /resets/:token(.:format)               resets#update
#            login GET    /login(.:format)                       sessions#login
#                  POST   /login(.:format)                       sessions#attempt_login
#           signup GET    /signup(.:format)                      sessions#signup
#                  POST   /signup(.:format)                      sessions#create
#           logout DELETE /logout(.:format)                      sessions#logout
 end