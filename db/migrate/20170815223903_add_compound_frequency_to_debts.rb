class AddCompoundFrequencyToDebts < ActiveRecord::Migration[5.1]
  def change
    add_column :debts, :compound_frequency, :string
  end
end
