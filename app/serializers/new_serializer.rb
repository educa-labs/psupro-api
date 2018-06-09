class NewSerializer < ActiveModel::Serializer
  attributes :id,:title,:lowering,:body, :date, :author
end
