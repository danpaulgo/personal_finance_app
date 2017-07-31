class AddUserIdToMultipleTables < ActiveRecord::Migration[5.1]
  def change
    add_column :expenses, :user_id, :integer
    add_column :incomes, :user_id, :integer
    add_column :liabilities, :user_id, :integer
    add_column :liquid_assets, :user_id, :integer
    add_column :non_liquid_assets, :user_id, :integer
    add_column :people, :user_id, :integer
  end
end
