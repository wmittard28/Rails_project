class Note < ApplicationRecord
    belongs_to :job_application
    has_one :user, :through => :job_application
    has_one :company, :through => :job_application

    validates :title, :presence   => true,
                      :uniqueness => {:scope => :job_application, :message => "has already been used"}
end
