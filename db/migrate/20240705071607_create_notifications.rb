class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :subtitle
      t.string :image_url
      t.references :coupon_offer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
