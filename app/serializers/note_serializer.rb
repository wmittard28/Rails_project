class NoteSerializer < ActiveModel::Serializer
    attributes :title, :content, :created_at
  end
