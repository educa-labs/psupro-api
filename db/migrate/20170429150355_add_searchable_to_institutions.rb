class AddSearchableToInstitutions < ActiveRecord::Migration[5.0]
  def change
    change_table :institutions do |t|
      t.change :title, :text
    end
  end
end
