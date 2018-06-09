class CreateInstitutionTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :institution_types do |t|
      t.string :title, default: ""
      t.integer :level_id

      t.timestamps
    end
    add_index :institution_types, :level_id
  end
end
