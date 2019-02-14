class CreateStockExchanges < ActiveRecord::Migration[5.2]
  def change
    create_table :stock_exchanges, id: :uuid do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.string :alpha_advantage_code, null: false
      t.string :country, null: false
      t.string :timeonze, null: false
      t.string :open, null: false
      t.string :close, null: false

      t.timestamps
    end

    add_index :stock_exchanges, [:code], unique: true
    add_index :stock_exchanges, [:alpha_advantage_code], unique: true
  end
end
