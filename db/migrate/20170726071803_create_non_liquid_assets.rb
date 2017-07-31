class CreateNonLiquidAssets < ActiveRecord::Migration[5.1]
  def change
    create_table :non_liquid_assets do |t|
      t.string :name
      t.float :value
      t.boolean :estimated_value
      t.integer :payoff_date
      t.boolean :estimated_payoff

      t.timestamps
    end
  end
end
