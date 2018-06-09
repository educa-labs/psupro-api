class CreateRegions < ActiveRecord::Migration[5.0]
  def change
    create_table :regions do |t|
      t.string :title, default: ""
      t.integer :country_id

      t.timestamps
    end
    add_index :regions, :country_id
  end
end
