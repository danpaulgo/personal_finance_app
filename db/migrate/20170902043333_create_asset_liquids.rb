class CreateAssetLiquids < ActiveRecord::Migration[5.1]
  def change
    create_table :asset_liquids do |t|
      t.integer :type_id
      t.string :name
      t.integer :user_id
      t.float :amount
      t.float :interest
      t.string :compound_frequency
      t.boolean :primary

      t.timestamps
    end
  end
end
