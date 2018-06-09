class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :auth_token, :first_name, :last_name, :admin
  
end
