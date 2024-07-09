class CreateTransactionHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :transaction_histories do |t|
      t.string :trans_type
      t.string :name
      t.string :coins, type: Integer, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
