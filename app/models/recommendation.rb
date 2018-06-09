class Recommendation < ApplicationRecord

  belongs_to :carreer
  belongs_to :user
  belongs_to :area

  validates :user_id, presence:true
  validates :carreer_id, presence:true
  # Validates that recommendation must be seen before being liked.
  validates :seen, inclusion: {in:[true],message: "Seen must be true if liked is true"}, if: :liked?
  validates_uniqueness_of :user_id, scope: :carreer_id

  def liked?
    self.liked
  end
end