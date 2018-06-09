class AddAreaidToCarreers < ActiveRecord::Migration[5.0]
  def change
    remove_column :carreers,:area
    add_column :carreers,:area_id, :integer
    add_index :carreers, :area_id
  end
end
