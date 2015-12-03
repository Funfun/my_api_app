class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :role
end
