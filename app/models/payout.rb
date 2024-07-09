class Payout < ApplicationRecord
  has_many :redeem_histories
end
