class FixIntroQuizComplete < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :into_quiz_complete, :intro_quiz_complete
  end
end
