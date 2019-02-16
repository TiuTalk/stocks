class RenameAlphaVantageColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :stock_exchanges, :alpha_advantage_code, :alpha_vantage_code
  end
end
