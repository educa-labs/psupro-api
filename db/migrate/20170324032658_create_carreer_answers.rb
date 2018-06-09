class CreateCarreerAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :carreer_answers do |t|
      t.integer :carreer_question_id
      t.integer :user_id
      t.string :answer, default: ""
      t.integer :likes, default: 0
      t.integer :dislikes, default: 0
      t.datetime :date

      t.timestamps
    end
    add_index :carreer_answers, :carreer_question_id
    add_index :carreer_answers, :user_id
  end
end
