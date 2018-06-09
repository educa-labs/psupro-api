class AddAuthorToNews < ActiveRecord::Migration[5.0]
  def change
    add_column :news, :author, :string
  end
end
