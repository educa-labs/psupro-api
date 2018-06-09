class CitySerializer < ActiveModel::Serializer
  attributes :id, :title, :region_id
end
