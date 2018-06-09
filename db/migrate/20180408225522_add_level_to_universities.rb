class AddLevelToUniversities < ActiveRecord::Migration[5.0]
  def change
    add_column :universities, :level, :integer, default: 0
  end
end
