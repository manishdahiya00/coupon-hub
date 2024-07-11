class ChangeColumns < ActiveRecord::Migration[7.1]
  def change
    change_column :coupon_offers, :hindi_desc, :text
  end
end
