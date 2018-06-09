class DropInstitutions < ActiveRecord::Migration[5.0]
  def change
    remove_column :universities, :institution_id
    add_column :universities, :title, :string
    drop_table :institutions
    drop_table :institution_types
  end
end
