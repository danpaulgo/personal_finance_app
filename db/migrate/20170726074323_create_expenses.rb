class CreateExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :expenses do |t|
      t.string :name
      t.float :amount
      t.string :frequency

      t.timestamps
    end
  end
end
