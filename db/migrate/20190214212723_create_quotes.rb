class CreateQuotes < ActiveRecord::Migration[5.2]
  def change
    create_table :quotes, id: :uuid do |t|
      t.references :stock, foreign_key: true, type: :uuid
      t.date :date, null: false
      t.decimal :open, precision: 6, scale: 2, null: false
      t.decimal :close, precision: 6, scale: 2, null: false
      t.decimal :high, precision: 6, scale: 2, null: false
      t.decimal :low, precision: 6, scale: 2, null: false

      t.timestamps
    end

    add_index :quotes, [:stock_id, :date], unique: true
  end
end
