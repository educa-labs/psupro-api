class AddInternalToRecommendations < ActiveRecord::Migration[5.0]
  def change
    add_column :recommendations, :essay, :boolean, default:false
    add_column :recommendations, :computed_area, :boolean, default:false
  end
end
