class AddImagesToUniversities < ActiveRecord::Migration[5.0]
  def change
    add_column :universities, :cover_picture,:string
    add_column :universities, :cover_extension,:string
    add_column :universities, :profile_picture,:string
    add_column :universities, :profile_extension,:string
  end
end
