class CreateUniversities < ActiveRecord::Migration[5.0]
  def change
    create_table :universities do |t|
      t.string :foundation , default: ""
      t.string :website , default: ""
      t.boolean :freeness, default: false
      t.string :motto , default: ""
      t.string :nick , default: ""
      t.integer :institution_id

      t.timestamps
    end
    add_index :universities, :institution_id
  end
end
