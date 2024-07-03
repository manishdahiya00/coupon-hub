class Admin::CouponStoresController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @stores = CouponStore.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end

  def new
    @store = CouponStore.new
  end

  def create
    @store = CouponStore.new(category_params)
    if @store.save
      redirect_to admin_coupon_stores_path, notice: "Category was successfully created."
    else
      render :new
    end
  end

  def edit
    @store = CouponStore.find(params[:id])
  end

  def update
    @store = CouponStore.find(params[:id])
    if @store.update(category_params)
      redirect_to admin_coupon_stores_path, notice: "Category was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @store = CouponStore.find(params[:id])
    @store.destroy
    redirect_to admin_coupon_stores_path, notice: "Category was successfully destroyed."
  end

  private

  def category_params
    params.require(:coupon_store).permit(:name, :img_url, :status, :coupon_category_id, :cashback, :action_url)
  end
end
