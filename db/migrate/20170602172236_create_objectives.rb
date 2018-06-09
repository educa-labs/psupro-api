class CreateObjectives < ActiveRecord::Migration[5.0]
  def change
    create_table :objectives do |t|
      t.integer :subject_id
      t.integer :score
      t.integer :user_id

      t.timestamps
    end
    add_index :objectives, :subject_id
    add_index :objectives, :user_id
  end
end
