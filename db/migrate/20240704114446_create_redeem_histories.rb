class CreateRedeemHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :redeem_histories do |t|
      t.string :upi_id
      t.float :coins
      t.string :phone
      t.string :amount
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
