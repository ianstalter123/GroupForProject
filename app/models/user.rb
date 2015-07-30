class User < ActiveRecord::Base
	has_secure_password
	validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
	validates :email, uniqueness: true
	validates :password, length: {minimum: 8, maximum: 20}

	has_many :articles

    def generate_password_reset_token!
    update(password_reset_token: SecureRandom.urlsafe_base64(48))
    end
end
