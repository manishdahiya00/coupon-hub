class CreateCouponOffers < ActiveRecord::Migration[7.1]
  def change
    create_table :coupon_offers do |t|
      t.string :name
      t.references :coupon_store, null: false, foreign_key: true
      t.references :coupon_category, null: false, foreign_key: true
      t.references :coupon_sub_category, null: false, foreign_key: true
      t.string :status
      t.string :short_desc
      t.text :long_desc
      t.string :country
      t.string :payout_type
      t.string :shop_type
      t.string :payout_cashback
      t.string :income_cashback
      t.string :offer_type
      t.string :img_url
      t.string :action_url
      t.string :hindi_desc
      t.string :currency
      t.string :priority
      t.string :code_show_text
      t.string :code_show_value

      t.timestamps
    end
  end
end
