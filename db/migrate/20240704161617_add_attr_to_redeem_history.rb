class AddAttrToRedeemHistory < ActiveRecord::Migration[7.1]
  def change
    add_column :redeem_histories, :status, :string, default: "PENDING"
  end
end
