class CreateRealEstateAppreciations < ActiveRecord::Migration[5.1]
  def change
    create_table :real_estate_appreciations do |t|
      t.string :state
      t.float :appreciation
      t.timestamps
    end
  end
end
