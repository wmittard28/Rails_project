class JobApplication < ApplicationRecord
    belongs_to :user
    belongs_to :company
    has_many :notes, :dependent => :destroy
    accepts_nested_attributes_for :company

    validate :start_date_before_end_date

    validates :start_date, :presence => true

    def company_attributes=(company) #setter method
      self.company = Company.find_or_create_by(company)
      self.company.update(company)
    end


    private

    def start_date_before_end_date #self allows you to acess current object
      if self.start_date.present? && self.end_date.present? && ( self.end_date - self.start_date ).to_i < 0
        errors.add(:end_date, "cannot be ahead of start date")
      end
    end
  end
