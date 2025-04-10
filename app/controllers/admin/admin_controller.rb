module Admin
  class AdminController < ApplicationController
    def authenticate_user!
      redirect_to admin_path unless current_user
    end

    def current_user
      session[:admin_authenticated] == true
    end

    def payout
      @redeem = RedeemHistory.find(params[:id])
      if params[:secret] == "5555"
        @redeem.update(status: "COMPLETED")
        redirect_to admin_user_path(@redeem.user), notice: "Payout Successfull"
      else
        redirect_to admin_user_path(@redeem.user), notice: "Invalid Secret Code"
      end
    end
  end
end
