class Country < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  has_many :regions
end
