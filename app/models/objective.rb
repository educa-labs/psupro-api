class Objective < ApplicationRecord
  belongs_to :user
  belongs_to :subject
  validates :score, allow_blank:true,numericality: {less_than_or_equal_to: 850, greater_than_or_equal_to: 250}
end
