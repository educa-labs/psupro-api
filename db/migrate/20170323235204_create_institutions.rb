class CreateInstitutions < ActiveRecord::Migration[5.0]
  def change
    create_table :institutions do |t|
      t.string :title, default: ""
      t.integer :institution_type_id

      t.timestamps
    end
    add_index :institutions, :institution_type_id
  end
end
