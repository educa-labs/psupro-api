class AddDemreIdToCarreers < ActiveRecord::Migration[5.0]
  def change
    add_column :carreers, :demre_id, :string
  end
end
