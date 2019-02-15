class AddEnabledToStocks < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :enabled, :boolean, default: true
  end
end
