class DropTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :liabilities
    drop_table :liquid_assets
    drop_table :non_liquid_assets
  end
end
