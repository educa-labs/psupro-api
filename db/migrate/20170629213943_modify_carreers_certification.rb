class ModifyCarreersCertification < ActiveRecord::Migration[5.0]
  def change
    add_column :carreers, :aux, :boolean

    Carreer.reset_column_information
    Carreer.all.each do |c|
      c.aux = c.certification > 0? true : false
      c.save
    end

    remove_column :carreers, :certification
    rename_column :carreers, :aux, :certification
  end
end
