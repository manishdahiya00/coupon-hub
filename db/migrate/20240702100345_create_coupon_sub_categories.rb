class CreateCouponSubCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :coupon_sub_categories do |t|
      t.references :coupon_category, null: false, foreign_key: true
      t.string :name
      t.string :status

      t.timestamps
    end
  end
end
