class User < ApplicationRecord
  has_many :app_opens, :dependent => :destroy
  has_many :transaction_histories, :dependent => :destroy
  has_many :redeem_histories, :dependent => :destroy
end
