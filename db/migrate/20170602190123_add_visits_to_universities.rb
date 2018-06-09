class AddVisitsToUniversities < ActiveRecord::Migration[5.0]
  def change
    add_column :universities, :visits, :integer, default:0
  end
end
