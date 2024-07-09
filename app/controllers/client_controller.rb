class ClientController < ApplicationController
  def index
    @banner_image = CouponOffer.second.img_url
    @categories = CouponCategory.active.limit(12)
    @stores = CouponStore.active.limit(12)
    @offers = CouponOffer.active.limit(12)
  end
end
