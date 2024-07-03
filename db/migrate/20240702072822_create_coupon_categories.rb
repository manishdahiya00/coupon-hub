class CreateCouponCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :coupon_categories do |t|
      t.string :name
      t.string :img_url
      t.string :status

      t.timestamps
    end
  end
end
