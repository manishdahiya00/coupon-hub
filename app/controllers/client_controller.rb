class ClientController < ApplicationController
  def index
    @app_banners = CouponOffer.limit(20).pluck(:img_url).to_a
    if @app_banners.nil?
      @banners = []
    else
      @banners = @app_banners
    end
    @categories = CouponCategory.active.limit(12)
    @stores = CouponStore.active.limit(12)
    @offers = CouponOffer.active.limit(12)
    @user = WebUser.find_by(security_token: session[:security_token])
  end
end
