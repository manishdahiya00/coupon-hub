module Admin
  class DashboardController < Admin::AdminController
    layout "admin"

    def index
      @users = User.count
      @Categories = CouponCategory.count
      @stores = CouponStore.count
      @offers = CouponOffer.count
    end
  end
end
