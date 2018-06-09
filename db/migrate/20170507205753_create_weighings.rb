class CreateWeighings < ActiveRecord::Migration[5.0]
  def change
    create_table :weighings do |t|
      t.integer :NEM
      t.integer :ranking
      t.integer :language
      t.integer :math
      t.integer :science
      t.integer :history
      t.integer :carreer_id

      t.timestamps
    end
    add_index :weighings, :carreer_id
  end
end
