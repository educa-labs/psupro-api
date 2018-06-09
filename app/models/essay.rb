class Essay < ApplicationRecord
  belongs_to :user
  belongs_to :subject

  validates :score, numericality: {less_than_or_equal_to: 850, greater_than_or_equal_to: 250}

  # Returns well formatted date_full if it exists.
  def date
    if self.date_full
      return self.date_full.strftime("%d-%m-%Y")
    end
    return nil
  end
end
