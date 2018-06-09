class CampuSerializer < ActiveModel::Serializer
  attributes :id, :title, :university_id,:lat, :long, :address, :city_id
end
