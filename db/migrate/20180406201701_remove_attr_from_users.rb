class RemoveAttrFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :rut
    remove_column :users, :birth_date
    remove_column :users, :city_id
    remove_column :users, :phone
    remove_column :users, :institution_id
    remove_column :users, :preuniversity
    remove_column :users, :notifications
    remove_column :users, :tutorial
    remove_column :users, :writer
  end
end
