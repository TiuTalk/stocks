class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks, id: :uuid do |t|
      t.string :name, null: false
      t.string :ticker, null: false
      t.string :type
      t.references :stock_exchange, foreign_key: true, type: :uuid, null: false

      t.timestamps
    end

    add_index :stocks, :ticker, unique: true
    add_index :stocks, :type
  end
end
