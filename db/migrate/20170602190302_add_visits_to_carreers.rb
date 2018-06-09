class AddVisitsToCarreers < ActiveRecord::Migration[5.0]
  def change
    add_column :carreers, :visits, :integer, default:0
  end
end
