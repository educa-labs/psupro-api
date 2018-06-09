class AddStuffToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string, default: ""
    add_column :users, :rut, :string, default: ""
    add_column :users, :birth_date, :datetime
    add_column :users, :city_id, :integer
    add_index :users, :city_id
    add_column :users, :phone, :string, default: ""
    add_column :users, :institution_id, :integer
    add_index :users, :institution_id
    add_column :users, :admin, :boolean, default: false
    add_column :users, :preuniversity, :boolean, default: false
    add_column :users, :notifications, :boolean, default: true
    add_column :users, :level_id, :integer
    add_index :users, :level_id
  end
end
