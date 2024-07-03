class Admin::CouponSubCategoriesController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @categories = CouponSubCategory.where(coupon_category_id: params[:coupon_category_id]).paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end

  def new
    @category = CouponSubCategory.new
  end

  def create
    @category = CouponSubCategory.new(category_params)
    @category.coupon_category_id = params[:coupon_category_id]
    if @category.save
      redirect_to admin_coupon_category_coupon_sub_categories_path, notice: "Category was successfully created."
    else
      render :new
    end
  end

  def edit
    @category = CouponSubCategory.find(params[:id])
  end

  def update
    @category = CouponSubCategory.find(params[:id])
    @category.coupon_category_id = params[:coupon_category_id]
    if @category.update(category_params)
      redirect_to admin_coupon_category_coupon_sub_categories_path, notice: "Category was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @category = CouponSubCategory.find(params[:id])
    @category.destroy
    redirect_to admin_coupon_category_coupon_sub_categories_path, notice: "Category was successfully destroyed."
  end

  private

  def category_params
    params.require(:coupon_sub_category).permit(:name, :status)
  end
end
