class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :liabilities, :person_company, :person_id
    add_column :liabilities,  :company, :string
  end
end
