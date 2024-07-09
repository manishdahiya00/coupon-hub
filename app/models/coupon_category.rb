class CouponCategory < ApplicationRecord
  has_many :coupon_stores, dependent: :destroy
  has_many :coupon_sub_categories, dependent: :destroy
  has_many :coupon_offers, dependent: :destroy

  scope :active, -> { where(:status => "active").order(created_at: :desc) }
end
