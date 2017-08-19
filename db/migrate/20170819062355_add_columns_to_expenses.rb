class AddColumnsToExpenses < ActiveRecord::Migration[5.1]
  def change
    add_column :expenses, :payment, :integer
    add_column :expenses, :payment_frequency, :string
  end
end
