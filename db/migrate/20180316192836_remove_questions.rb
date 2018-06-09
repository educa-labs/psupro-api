class RemoveQuestions < ActiveRecord::Migration[5.0]

  def change
    drop_table :carreer_answers
    drop_table :carreer_questions
    drop_table :university_answers
    drop_table :university_questions
  end
end
