class AddSubjectToEssays < ActiveRecord::Migration[5.0]
  def change
    remove_column :essays, :subject
    add_column :essays, :subject_id, :integer
    add_index :essays, :subject_id
  end
end
