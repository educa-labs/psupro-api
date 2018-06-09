class CreateRecommendations < ActiveRecord::Migration[5.0]
  def change
    create_table :recommendations do |t|
      t.integer :user_id
      t.integer :carreer_id
      t.integer :area_id
      t.boolean :liked , default: false
      t.boolean :seen, default: false
      t.timestamps
    end
    add_index :recommendations, :user_id
    add_index :recommendations, :area_id
    add_index :recommendations, :carreer_id
  end
end
