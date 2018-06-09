class EssaySerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :score, :date
  belongs_to :subject
end
