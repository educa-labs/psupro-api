class AddDateToEssays < ActiveRecord::Migration[5.0]
  def change
    add_column :essays, :date_full, :datetime
  end
end
