class AddSearchableToUniversities < ActiveRecord::Migration[5.0]
  def change
    change_table :universities do |t|
      t.change :nick, :text
    end
  end
end
