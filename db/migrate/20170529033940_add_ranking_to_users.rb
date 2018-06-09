class AddRankingToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :ranking, :integer
  end
end
