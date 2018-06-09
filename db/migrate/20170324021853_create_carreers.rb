class CreateCarreers < ActiveRecord::Migration[5.0]
  def change
    create_table :carreers do |t|
      t.string :title, default: ""
      t.integer :university_id
      t.integer :campu_id
      t.integer :certification, default: 0
      t.integer :semesters, default: 0
      t.integer :price, default:0
      t.string :area, default: ""
      t.string :schedule, default: ""
      t.integer :openings, default: 0
      t.float :employability, default: 0
      t.integer :income, default: 0

      t.timestamps
    end
    add_index :carreers, :university_id
    add_index :carreers, :campu_id
  end
end
