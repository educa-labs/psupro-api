class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
      t.text :body
      t.text :title
      t.text :lowering
      t.text :picture
      t.string :extension

      t.timestamps
    end
  end
end
