class Campu < ApplicationRecord
  validates_presence_of :title, :university_id, :city_id, :address
  belongs_to :city
  belongs_to :university
  has_many :carreers

end
