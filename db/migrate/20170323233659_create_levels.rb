class CreateLevels < ActiveRecord::Migration[5.0]
  def change
    create_table :levels do |t|
      t.string :title, default: ""

      t.timestamps
    end
  end
end