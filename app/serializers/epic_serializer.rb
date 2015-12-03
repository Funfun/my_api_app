class EpicSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :priority
end
