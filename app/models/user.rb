class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { email.downcase! } #makes the submitted emai lower-case
  validates :name,  presence: true, length: { maximum: 50 } #makes sure there is a non blank name
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, #ensures email is valid
                    format: { with: VALID_EMAIL_REGEX }, #correct format
                    uniqueness: { case_sensitive: false } #that its unique
  has_secure_password   #is hashed
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true #password is nonblank and has atlest 6 characters

  class << self
    # Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token # sets remember token unique to current user equal to urlsafe_base64
    update_attribute(:remember_digest, User.digest(remember_token)) # updates remember digest with rmember token params
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user
  def forget
    update_attribute(:remember_digest, nil)
  end
end
