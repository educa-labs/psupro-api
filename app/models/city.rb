class City < ApplicationRecord
  validates :title, :region_id, presence: true
  belongs_to :region
  has_many :campus
  has_many :universities, through: :campus
end
