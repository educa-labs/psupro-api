class CreateCarreersUsersJoinTable < ActiveRecord::Migration[5.0]
  def change
    create_table :carreers_users, id: false do |t|
      t.integer :user_id
      t.integer :carreer_id
    end
    add_index :carreers_users, [:user_id, :carreer_id], :unique => true
    add_index :carreers_users, :carreer_id
  end
end
