class RedeemHistory < ApplicationRecord
  belongs_to :user
  belongs_to :payout
end
