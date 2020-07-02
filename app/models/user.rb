class User < ApplicationRecord
    has_many :job_applications, :dependent => :destroy
    has_many :companies, :through => :job_applications
    has_many :notes, :through => :job_applications

    has_secure_password

    before_validation :create_slug_from_username
    validate :slug_is_present_and_unique

    validates :username, :presence   => true,
                         :uniqueness => true,
                         :format     => {:without => /\A.*\@.*\z/}

    validates :email,    :presence   => true,
                         :uniqueness => true,
                         :format     => {:with => /\A\w+\@\w+\.\w+\z/}

    def self.find_or_create_by_omniauth(auth_hash)
      attribute = self.set_omniauth_query_attribute(auth_hash)
      self.find_or_create_by(attribute) do |user|
        user.username      = self.set_omniauth_username(auth_hash)
        user.email      = self.set_omniauth_email(auth_hash)
        user.uid = auth_hash[:uid]
        user.password   = SecureRandom.hex
      end
    end

    def self.most_job_applications(n = 15)
      self.left_joins(:companies)
          .group(:username)
          .order("COUNT(companies.id) DESC")
          .limit(n)
    end

    def future_job_applications
      self.job_applications.where("start_date >= ?", Time.now.to_date)
                  .order("start_date")
    end

    def past_job_applications
      self.job_applications.where("start_date < ?", Time.now.to_date)
                  .order("start_date DESC")
    end

    def public_attributes
      self.attributes.except("id", "password_digest", "uid", "created_at", "updated_at")
    end

    def uniq_companies
      self.companies.group(:name).order(:name)
    end

    def to_param
      self.slug
    end

    private

    def create_slug_from_username
      self.slug = self.username.try(:parameterize)
    end

    def slug_is_present_and_unique
      if self.slug.present? && self.class.where.not(:id => self.id).where(:slug => self.slug).any?
        errors.add(:username, "(slug) has already been taken")
      end
    end

    def self.set_omniauth_query_attribute(auth_hash)
      if auth_hash[:info][:email].present? then { :email => auth_hash[:info][:email] }
      else { :uid => auth_hash[:uid] }
      end
    end

    def self.set_omniauth_username(auth_hash)
      username = if auth_hash[:info][:nickname].present? then auth_hash[:info][:nickname]
                 else auth_hash[:uid]
                 end
      if self.where(:username => username).any?
        username += "_0001"
        while self.where(:username => username).any?
          username[-4..-1] = (1+username[-4..-1].to_i).to_s.rjust(4, "0")
        end
      end
      username
    end

    def self.set_omniauth_email(auth_hash)
      email = if auth_hash[:info][:email].present? then auth_hash[:info][:email]
              else auth_hash[:uid] + "@" + auth_hash[:provider] + ".com"
              end
      if self.where(:email => email).any?
        email = email.split(/(?=\@)/).join("_0001")
        while self.where(:email => email).any?
          local_part, domain = email.split(/(?=\@)/)
          local_part[-4..-1] = (1+local_part[-4..-1].to_i).to_s.rjust(4, "0")
          email = local_part + domain
        end
      end
      email
    end
  end
