class CreateAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :assets do |t|
      t.string :name
      t.float :amount
      t.boolean :liquid

      t.timestamps
    end
  end
end
