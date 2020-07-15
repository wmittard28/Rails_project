class Company < ApplicationRecord
    has_many :job_applications
    has_many :users, :through => :job_applications
    has_many :notes, :through => :job_applications

    before_validation :create_slug_from_name
    validate :slug_is_present_and_unique

    validates :name, :presence   => true, :uniqueness => true

    def self.most_popular(n = 15) #scope method
      self.left_joins(:users).group(:name).order("COUNT(users.id) DESC").limit(n)
    end

    def to_param
      self.slug
    end

    private

    def create_slug_from_name #creates slug for company rankings in URL
      self.slug = self.name.try(:parameterize)
    end

    def slug_is_present_and_unique
      if self.slug.present? && self.class.where.not(:id => self.id).where(:slug => self.slug).any?
        errors.add(:name, "(slug) already exists")
      end
    end
end
