class User < ApplicationRecord
    has_many :job_applications, :dependent => :destroy #built in to signify to AR what happens when object is destroyed
    has_many :companies, :through => :job_applications
    has_many :notes, :through => :job_applications

    has_secure_password #uses Bcrypt

    before_validation :create_slug_from_username

    validates :username, :presence   => true,:uniqueness => true
    validates :email,    :presence   => true, :uniqueness => true

      def self.find_or_create_by_omniauth(auth)
        where(email: auth.info.email).first_or_initialize do |user|
          user.user_name = auth.info.name
          user.email = auth.info.email
          user.password = SecureRandom.hex
        end
      end


    def current_job_applications #scope method
      self.job_applications.where("start_date >= ?", Time.now.to_date).order("start_date")
    end

    def expired_job_applications #scope method
      self.job_applications.where("start_date < ?", Time.now.to_date).order("start_date DESC")
    end

    def public_attributes #what can't be accessed in users account
      self.attributes.except("id", "slug", "provider", "password_digest", "uid", "created_at", "updated_at")
    end

    def uniq_companies
      self.companies.group(:name).order(:name)
    end

    def to_param #allows me override user_id in URL for slug
      self.slug
    end

    private

    def create_slug_from_username
      self.slug = self.username.try(:parameterize) #allows a user to sign up and create slug from username
    end
end
