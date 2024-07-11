class ClientController < ApplicationController
  layout "client"

  def index
    @app_banners = CouponOffer.limit(20).pluck(:img_url).to_a
    @banners = ["https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fstatic.vecteezy.com%2Fsystem%2Fresources%2Fpreviews%2F002%2F006%2F774%2Flarge_2x%2Fpaper-art-shopping-online-on-smartphone-and-new-buy-sale-promotion-backgroud-for-banner-market-ecommerce-free-vector.jpg&f=1&nofb=1&ipt=2464ab48060099af94310cf8f60ebe356b29188c99d88dbe89d1d42ea408bd89&ipo=images", "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fstatic.vecteezy.com%2Fsystem%2Fresources%2Fpreviews%2F002%2F453%2F533%2Fnon_2x%2Fbig-sale-discount-banner-template-promotion-illustration-free-vector.jpg&f=1&nofb=1&ipt=a556b5f2c142ff6563a2a224d9ab7abd32b0fc6961378a5778f653d489a6d2ea&ipo=images"]
    @categories = CouponCategory.active.limit(12)
    @stores = CouponStore.active.limit(12)
    @offers = CouponOffer.active.limit(12)
    @user = WebUser.find_by(security_token: session[:security_token])
  end

  def categories
    @categories = CouponCategory.active
  end

  def offers
    @offers = CouponOffer.active
  end

  def stores
    @stores = CouponStore.active
  end

  def store_page
    @store = CouponStore.active.find_by(id: params[:id])
    @offers = @store&.coupon_offers&.active || []
  end

  def category_page
    @category = CouponCategory.active.find_by(id: params[:id])
    @offers = @category&.coupon_offers&.active || []
  end

  def offer_page
    @offer = CouponOffer.active.find_by(id: params[:id])
    @offers = @offer.coupon_category.coupon_offers.active.where.not(id: @offer.id)
  end

  def offer_show
    @offer = CouponOffer.active.find_by(id: params[:id])
  end
end
