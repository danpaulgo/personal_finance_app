class AddCompoundFrequencyToAssets < ActiveRecord::Migration[5.1]
  def change
    add_column :assets, :compound_frequency, :string
  end
end
