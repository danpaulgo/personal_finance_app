class CreateAssetNonLiquids < ActiveRecord::Migration[5.1]
  def change
    create_table :asset_non_liquids do |t|
      t.integer :type_id
      t.string :name
      t.integer :user_id
      t.float :amount
      t.float :interest
      t.string :compound_frequency

      t.timestamps
    end
  end
end
