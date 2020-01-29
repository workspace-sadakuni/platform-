Rails.application.routes.draw do
  root "home#top"

  post 'applicant/:post_id/create' => "applicants#create"
  post 'applicant/:post_id/destroy' => "applicants#destroy"
  post 'applicant/:post_id/achieved' => "applicants#achieved"
  post 'applicant/:post_id/destroy_achieved' => "applicants#destroy_achieved"

  get 'login' => "users#login_form"
  post 'login' => "users#login"
  post 'logout' => "users#logout"

  post 'users/:id/update' => "users#update"
  post 'users/:id/destroy' => "users#destroy"
  get 'users/:id/edit' => "users#edit"
  post 'users/create' => "users#create"
  get 'signup' => "users#new"
  get 'users/index' => "users#index"
  get 'users/:id' => "users#show"
  get 'users/:id/applicants' => "users#applicants"

  get 'posts/index' => "posts#index"
  get 'posts/new' => "posts#new"
  get 'posts/:id' => "posts#show"
  post 'posts/create' => "posts#create"
  get 'posts/:id/edit' => "posts#edit"
  post 'posts/:id/update' => "posts#update"
  post 'posts/:id/destroy' => "posts#destroy"

  get '/' => "home#top"
  get 'about' => "home#about"

  get 'auth/:provider/callback' => "users#create_twitter"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
