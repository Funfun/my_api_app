class StorySerializer < ActiveModel::Serializer
  attributes :id, :body, :status, :epic_id
end
