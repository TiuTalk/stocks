class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets, id: :uuid do |t|
      t.references :user, foreign_key: true, type: :uuid
      t.references :stock_exchange, foreign_key: true, type: :uuid
      t.string :name, null: false

      t.timestamps
    end
  end
end
