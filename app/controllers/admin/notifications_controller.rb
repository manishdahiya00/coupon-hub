class Admin::NotificationsController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @notifications = Notification.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end
end
