class AddTypeidToCarreers < ActiveRecord::Migration[5.0]
  def change
    remove_column :universities, :finance_type
    add_column :universities, :university_type_id, :integer
    add_index :universities, :university_type_id
  end
end
