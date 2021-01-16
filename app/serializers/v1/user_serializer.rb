class V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :created_at
end
