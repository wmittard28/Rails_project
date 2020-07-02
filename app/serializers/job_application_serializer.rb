class JobApplicationSerializer < ActiveModel::Serializer
    attributes :id, :position, :status, :start_date, :end_date
    belongs_to :user
    belongs_to :company
    has_many :notes
  end
