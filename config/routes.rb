Rails.application.routes.draw do
  mount API::Base => "/"
  root "main#index"

  get "/admin/dashboard" => "admin/dashboard#index"
  get "/admin" => "admin/login#new"
  post "/admin" => "admin/login#login"
  delete "/admin/logout" => "admin/login#logout"

  namespace :admin do
    resources :users
    resources :coupon_categories do
      resources :coupon_sub_categories
    end
    resources :coupon_stores
    resources :coupon_offers
  end
end
