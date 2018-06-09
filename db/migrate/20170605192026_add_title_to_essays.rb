class AddTitleToEssays < ActiveRecord::Migration[5.0]
  def change
    add_column :essays, :title, :string
  end
end
