class WeighingSerializer < ActiveModel::Serializer
  attributes :id, :NEM, :ranking, :language, :math
  attribute :history, if: :has_history?
  attribute :science, if: :has_science?

  # Methods for conditional serialization.
  def has_history?
    !object.history.nil?
  end

  def has_science?
    !object.science.nil?
  end

end
