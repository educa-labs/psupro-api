class AddSearchableToCarreers < ActiveRecord::Migration[5.0]
  def change
    change_table :carreers do |t|
      t.change :title, :text

    end
  end
end
