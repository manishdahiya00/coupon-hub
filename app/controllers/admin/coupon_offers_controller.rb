class Admin::CouponOffersController < Admin::AdminController
  before_action :authenticate_user!
  layout "admin"

  def index
    @offers = CouponOffer.all.paginate(page: params[:page], per_page: 20).order(created_at: :desc)
  end

  def new
    @offer = CouponOffer.new
  end

  def create
    @offer = CouponOffer.new(offer_params)
    if @offer.save
      @offer.notifications.create(title: @offer.name, subtitle: @offer.long_desc, image_url: @offer.img_url)
      redirect_to admin_coupon_offers_path, notice: "Coupon offer was successfully created."
    else
      render :new
    end
  end

  def edit
    @offer = CouponOffer.find(params[:id])
  end

  def update
    @offer = CouponOffer.find(params[:id])
    if @offer.update(offer_params)
      redirect_to admin_coupon_offers_path, notice: "Coupon offer was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @offer = CouponOffer.find(params[:id])
    @offer.destroy
    redirect_to admin_coupon_offers_path, notice: "Coupon offer was successfully destroyed."
  end

  private

  def offer_params
    params.require(:coupon_offer).permit(
      :name, :coupon_store_id, :coupon_category_id, :coupon_sub_category_id, :status, :short_desc,
      :long_desc, :country, :payout_type, :shop_type, :payout_cashback, :income_cashback, :offer_type,
      :img_url, :action_url, :hindi_desc, :currency, :priority, :code_show_text, :code_show_value
    )
  end
end
