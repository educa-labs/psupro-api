class CarreerSerializer < ActiveModel::Serializer
  attributes :id, :title,:university_title,:campu_name,:campu_id,:certification, :area_id,:semesters,
             :price,:area_title,:schedule,:openings,:employability,:income, :university_id,
             :admission, :last_cut,:degree_type, :description, :visits

  belongs_to :university

  has_one :weighing

  attribute :area_picture, if: :render_picture?

  def render_picture?
    object.render_picture
  end

end