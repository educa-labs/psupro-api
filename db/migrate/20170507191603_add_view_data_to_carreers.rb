class AddViewDataToCarreers < ActiveRecord::Migration[5.0]
  def change
    add_column :carreers, :admission, :string, default:"PSU"
    add_column :carreers, :last_cut, :integer
    add_column :carreers, :description, :text, default:""
  end
end
