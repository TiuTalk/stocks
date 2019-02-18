class CreateOperations < ActiveRecord::Migration[5.2]
  def change
    create_table :operations, id: :uuid do |t|
      t.references :wallet, foreign_key: true, type: :uuid
      t.references :stock, foreign_key: true, type: :uuid
      t.string :type
      t.integer :quantity, null: false
      t.decimal :price, precision: 6, scale: 2, null: false
      t.decimal :taxes, precision: 6, scale: 2, null: false, default: 0
      t.decimal :total, precision: 6, scale: 2, null: false
      t.date :date, null: false

      t.timestamps
    end
  end
end
