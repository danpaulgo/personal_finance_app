class AddNameToTransfers < ActiveRecord::Migration[5.1]
  def change
    add_column :transfers, :name, :string
  end
end
