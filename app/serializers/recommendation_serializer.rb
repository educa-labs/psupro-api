class RecommendationSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :area_id,:liked,:seen
  belongs_to :carreer
end
