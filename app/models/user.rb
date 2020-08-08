class User < ApplicationRecord

    before_save :downcase_email

    has_many :recipes, dependent: :destroy

    MAX_LENGTH_HANDLE_NAME = 30
    MAX_LENGTH_FIRST_NAME = 30
    MAX_LENGTH_LAST_NAME = 30
    MAX_LENGTH_EMIAL = 50
    MIN_LENGTH_PASSWORD = 6
    VALID_EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

    validates :handle_name, presence: true, length: { maximum: MAX_LENGTH_HANDLE_NAME },
              uniqueness: true
    validates :first_name, presence: true, length: { maximum: MAX_LENGTH_FIRST_NAME }
    validates :last_name, presence: true, length: { maximum: MAX_LENGTH_LAST_NAME }
    validates :email, presence: true, length: { maximum: MAX_LENGTH_EMIAL },
              uniqueness: true, format: { with: VALID_EMAIL_REGEX }

    has_secure_password
    validates :password, presence: true, length: { minimum: MIN_LENGTH_PASSWORD }

    def full_name
        [first_name, last_name].join(" ")
    end
    
    def username
        "@" + handle_name
    end

    private
    def downcase_email
        self.email = email.downcase
    end
end
