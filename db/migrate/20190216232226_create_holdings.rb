class CreateHoldings < ActiveRecord::Migration[5.2]
  def change
    create_table :holdings, id: :uuid do |t|
      t.references :wallet, foreign_key: true, type: :uuid
      t.references :stock, foreign_key: true, type: :uuid
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end
  end
end
