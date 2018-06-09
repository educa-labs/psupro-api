class DropUserPictures < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :picture
    remove_column :users, :extension
  end
end
