class AddVolumeToQuotes < ActiveRecord::Migration[5.2]
  def change
    add_column :quotes, :volume, :integer, null: false
  end
end
