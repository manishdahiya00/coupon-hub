Rails.application.routes.draw do
  root "client#index"
  get "/google_login" => "auth#google_login"
  get "/logout" => "auth#logout"
  get "/store/:id" => "client#store_page", as: "store"
  get "/category/:id" => "client#category_page", as: "category"
  get "/offer/:id" => "client#offer_page", as: "offer"
  get "/offer/action/:id" => "client#offer_show", as: "offer_show"
  get "/categories" => "client#categories", as: "categories"
  get "/offers" => "client#offers", as: "offers"
  get "/stores" => "client#stores", as: "stores"
  get "/invite/:ref_code" => "client#invite"
  get "/admin/dashboard" => "admin/dashboard#index"
  get "/admin" => "admin/login#new"
  post "/admin" => "admin/login#login"
  delete "/admin/logout" => "admin/login#logout"

  namespace :admin do
    post "/payout_user/:id", to: "admin#payout", as: "payout_user"
    resources :payouts
    resources :users
    resources :coupon_categories do
      resources :coupon_sub_categories
    end
    resources :coupon_stores
    resources :coupon_offers
    resources :redeem_histories
    resources :notifications
  end
  mount API::Base => "/"
end
