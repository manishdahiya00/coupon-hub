class AddAttrToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :wallet_balance, :float, default: 0
    add_column :users, :last_check_in, :datetime
    add_column :users, :phone, :string
  end
end
