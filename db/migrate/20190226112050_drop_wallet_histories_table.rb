class DropWalletHistoriesTable < ActiveRecord::Migration[5.2]
  def up
    drop_table :wallet_histories
  end
end
