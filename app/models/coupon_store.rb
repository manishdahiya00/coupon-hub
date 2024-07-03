class CouponStore < ApplicationRecord
  belongs_to :coupon_category
  has_many :coupon_offers, dependent: :destroy

  scope :active, -> { where(:status => "active") }
end
