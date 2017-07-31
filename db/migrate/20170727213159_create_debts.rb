class CreateDebts < ActiveRecord::Migration[5.1]
  def change
    create_table :debts do |t|
      t.string :name
      t.float :amount
      t.string :description

      t.timestamps
    end
  end
end
