class DropLevels < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :level_id
    drop_table :levels
  end
end
