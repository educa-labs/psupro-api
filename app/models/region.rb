class Region < ApplicationRecord
  validates :title, :country_id, presence: true
  belongs_to :country
  has_many :cities
end
