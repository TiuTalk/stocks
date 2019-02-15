class CreateSectors < ActiveRecord::Migration[5.2]
  def change
    create_table :sectors, id: :uuid do |t|
      t.references :stock_exchange, foreign_key: true, type: :uuid
      t.string :name, null: false

      t.timestamps
    end

    add_reference :stocks, :sector, foreign_key: true, type: :uuid
  end
end
