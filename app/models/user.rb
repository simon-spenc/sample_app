class User < ApplicationRecord
  before_save { email.downcase! } #makes the submitted emai lower-case
  validates :name,  presence: true, length: { maximum: 50 } #makes sure there is a non blank name
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, #ensures email is valid
                    format: { with: VALID_EMAIL_REGEX }, #correct format
                    uniqueness: { case_sensitive: false } #that its unique
  has_secure_password   #is hashed
  validates :password, presence: true, length: { minimum: 6 } #password is nonblank and has atlest 6 characters

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

end
