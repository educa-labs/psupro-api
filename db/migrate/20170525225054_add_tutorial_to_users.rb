class AddTutorialToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :tutorial, :boolean, default: false
  end
end
