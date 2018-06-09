class CreateCampus < ActiveRecord::Migration[5.0]
  def change
    create_table :campus do |t|
      t.string :title, default: ""
      t.integer :university_id
      t.string :lat, default: ""
      t.string :long, default: ""
      t.string :address, default: ""
      t.integer :city_id

      t.timestamps
    end
    add_index :campus, :university_id
    add_index :campus, :city_id
  end
end
