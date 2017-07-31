class CreateLiabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :liabilities do |t|
      t.string :name
      t.float :amount
      t.boolean :person_or_company
      t.string :person_company

      t.timestamps
    end
  end
end
