class CreateCouponStores < ActiveRecord::Migration[7.1]
  def change
    create_table :coupon_stores do |t|
      t.references :coupon_category, null: false, foreign_key: true
      t.string :name
      t.string :cashback
      t.string :action_url
      t.string :img_url
      t.string :status

      t.timestamps
    end
  end
end
