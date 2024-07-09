class Admin::RedeemHistoriesController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @redeems = RedeemHistory.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end

  def show
    @redeem = User.find(params[:id])
  end
end
