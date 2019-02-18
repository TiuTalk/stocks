class AddFieldsToHoldings < ActiveRecord::Migration[5.2]
  def up
    add_column :holdings, :invested, :decimal, precision: 10, scale: 2, null: false, default: 0
    add_column :holdings, :average_price, :decimal, precision: 6, scale: 2, null: false, default: 0
    add_column :holdings, :accounting_average_price, :decimal, precision: 6, scale: 2, null: false, default: 0
    change_column_default :holdings, :quantity, 0

    change_column :operations, :price, :decimal, precision: 10, scale: 2, null: false
    change_column :operations, :total, :decimal, precision: 10, scale: 2, null: false
  end

  def down
    remove_columns :holdings, :invested, :average_price, :accounting_average_price
    change_column_default :holdings, :quantity, 1

    change_column :operations, :price, :decimal, precision: 6, scale: 2, null: false
    change_column :operations, :total, :decimal, precision: 6, scale: 2, null: false
  end
end
