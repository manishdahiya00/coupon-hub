class Admin::CouponCategoriesController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @categories = CouponCategory.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end

  def new
    @category = CouponCategory.new
  end

  def create
    @category = CouponCategory.new(category_params)
    if @category.save
      redirect_to admin_coupon_categories_path, notice: "Category was successfully created."
    else
      render :new
    end
  end

  def edit
    @category = CouponCategory.find(params[:id])
  end

  def update
    @category = CouponCategory.find(params[:id])
    if @category.update(category_params)
      redirect_to admin_coupon_categories_path, notice: "Category was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @category = CouponCategory.find(params[:id])
    @category.destroy
    redirect_to admin_coupon_categories_path, notice: "Category was successfully destroyed."
  end

  private

  def category_params
    params.require(:coupon_category).permit(:name, :img_url, :status)
  end
end
