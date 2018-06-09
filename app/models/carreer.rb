class Carreer < ApplicationRecord


  searchkick language: "spanish"
  scope :search_import, -> { includes(:university,:campu) }
  attr_accessor :render_picture
  def search_data
    {
      title: title,
      desciption: description,
      degree_type: degree_type,
      city_id: city_id,
      region_id: region_id
    }
  end

  validates_presence_of :university_id, :campu_id, :title
  belongs_to :university
  belongs_to :campu
  belongs_to :area
  has_many :carreer_questions
  has_and_belongs_to_many :users
  has_one :weighing
  delegate :city_id, to: :campu
  delegate :city, to: :campu
  delegate :title, to: :area, prefix: true

  def university_title
    self.university.title
  end

  def university_initials
    self.university.initials
  end

  def campu_name
    self.campu.title
  end

  def region_id
    self.city.region_id
  end

  # Returns true if self doesn't have the minimum valid weighings.
  def weighing?
    not(self.weighing.language.nil? || self.weighing.math.nil?)
  end

  def area_picture
    self.area.encoded_picture
  end

end
