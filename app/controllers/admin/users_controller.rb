class Admin::UsersController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @users = User.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
  end

  def payout
    @redeem = Redeem.find(params[:id])
    @user = User.find(@redeem.user_id)
    if params[:secret] == "5555"
      @redeem.update(status: "COMPLETED")
      redirect_to admin_user_path(@user), notice: "Payout Successfull"
    else
      redirect_to admin_user_path(@user), notice: "Invalid Secret Code"
    end
  end
end
