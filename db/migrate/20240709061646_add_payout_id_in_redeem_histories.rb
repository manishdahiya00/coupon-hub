class AddPayoutIdInRedeemHistories < ActiveRecord::Migration[7.1]
  def change
    add_column :redeem_histories, :payout_id, :string
  end
end
