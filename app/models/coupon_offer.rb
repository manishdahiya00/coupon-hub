class CouponOffer < ApplicationRecord
  belongs_to :coupon_store
  belongs_to :coupon_category
  belongs_to :coupon_sub_category

  scope :active, -> { where(:status => "active") }
end
