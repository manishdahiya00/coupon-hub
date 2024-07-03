class User < ApplicationRecord
  has_many :app_opens, :dependent => :destroy
end
