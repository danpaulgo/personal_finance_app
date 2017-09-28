class CreateTransfers < ActiveRecord::Migration[5.1]
  def change
    create_table :transfers do |t|
      t.integer :user_id
      t.integer :liquid_asset_from_id
      t.integer :destination_id
      t.string :type
      t.datetime :next_date
      t.float :amount
      t.string :frequency

      t.timestamps
    end
  end
end
