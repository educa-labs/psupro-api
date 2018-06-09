class AddNemToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :nem, :float
  end
end
