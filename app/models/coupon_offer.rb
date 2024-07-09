class CouponOffer < ApplicationRecord
  belongs_to :coupon_store
  belongs_to :coupon_category
  belongs_to :coupon_sub_category
  has_many :notifications, dependent: :destroy
  scope :active, -> { where(:status => "active").order(created_at: :desc) }
end
