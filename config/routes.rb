Rails.application.routes.draw do
  root "client#index"
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
