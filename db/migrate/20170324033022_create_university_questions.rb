class CreateUniversityQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :university_questions do |t|
      t.integer :university_id
      t.integer :user_id
      t.string :question, default: ""
      t.string :details, default: ""
      t.integer :likes, default: 0
      t.integer :dislikes, default: 0
      t.datetime :date

      t.timestamps
    end
    add_index :university_questions, :university_id
    add_index :university_questions, :user_id
  end
end
