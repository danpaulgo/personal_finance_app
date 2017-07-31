class CreateIncomes < ActiveRecord::Migration[5.1]
  def change
    create_table :incomes do |t|
      t.float :amount
      t.string :frequency

      t.timestamps
    end
  end
end
