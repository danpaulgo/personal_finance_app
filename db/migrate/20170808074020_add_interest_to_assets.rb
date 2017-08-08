class AddInterestToAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :interest, :float
  end
end
