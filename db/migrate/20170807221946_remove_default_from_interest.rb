class RemoveDefaultFromInterest < ActiveRecord::Migration[5.1]
  def change
    change_column :debts, :interest, :float, :default => nil
  end
end
