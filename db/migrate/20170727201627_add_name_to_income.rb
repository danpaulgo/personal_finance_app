class AddNameToIncome < ActiveRecord::Migration[5.1]
  def change
    add_column :incomes, :name, :string
  end
end
