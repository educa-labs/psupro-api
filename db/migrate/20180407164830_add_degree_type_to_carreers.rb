class AddDegreeTypeToCarreers < ActiveRecord::Migration[5.0]
  def change
    add_column :carreers, :degree_type, :int
  end
end
