class CreateEssays < ActiveRecord::Migration[5.0]
  def change
    create_table :essays do |t|
      t.string :subject
      t.integer :score
      t.integer :user_id

      t.timestamps
    end
    add_index :essays, :user_id
  end
end
