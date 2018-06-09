class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.string :title, default: ""
      t.integer :region_id

      t.timestamps
    end
    add_index :cities, :region_id
  end
end
