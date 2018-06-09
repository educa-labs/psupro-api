class AddViewDataToUniversities < ActiveRecord::Migration[5.0]
  def change
    add_column :universities, :finance_type, :string, default:"privada"
    add_column :universities, :initials, :text, default:""
    add_column :universities, :students, :integer
    add_column :universities, :teachers, :integer
    add_column :universities, :degrees, :integer
    add_column :universities, :postgraduates, :integer
    add_column :universities, :doctorates, :integer
    add_column :universities, :description, :text, default:""
  end
end
