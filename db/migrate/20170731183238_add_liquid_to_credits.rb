class AddLiquidToCredits < ActiveRecord::Migration[5.1]
  def change
    add_column :credits, :liquid, :boolean
  end
end
