class V1::ComicSerializer < ActiveModel::Serializer
  attributes :id, :title, :volume, :user

  belongs_to :user
end