class AddInterestToDebts < ActiveRecord::Migration[5.1]
  def change
    add_column :debts, :interest, :float, default: 0.0
  end
end
