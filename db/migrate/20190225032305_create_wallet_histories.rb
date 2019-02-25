class CreateWalletHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :wallet_histories, id: :uuid do |t|
      t.references :wallet, foreign_key: true, type: :uuid
      t.decimal :invested, :decimal, precision: 10, scale: 2, null: false, default: 0
      t.decimal :value, :decimal, precision: 10, scale: 2, null: false, default: 0
      t.date :date, null: false

      t.timestamps
    end

    add_index :wallet_histories, %i[wallet_id date], unique: true
  end
end
