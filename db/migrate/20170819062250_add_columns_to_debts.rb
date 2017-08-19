class AddColumnsToDebts < ActiveRecord::Migration[5.1]
  def change
    add_column :debts, :payment, :integer
    add_column :debts, :payment_frequency, :string
    add_column :debts, :string, :string
  end
end
