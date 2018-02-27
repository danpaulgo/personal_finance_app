class AddIntroQuizCoCompleteToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :into_quiz_complete, :boolean, default: false
  end
end
