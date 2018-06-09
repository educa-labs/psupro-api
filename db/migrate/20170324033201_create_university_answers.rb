class CreateUniversityAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :university_answers do |t|
      t.integer :university_question_id
      t.integer :user_id
      t.string :answer, default: ""
      t.integer :likes, default: 0
      t.integer :dislikes, default: 0
      t.datetime :date

      t.timestamps
    end
    add_index :university_answers, :university_question_id
    add_index :university_answers, :user_id
  end
end
