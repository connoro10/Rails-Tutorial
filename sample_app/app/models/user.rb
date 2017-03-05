class User < ApplicationRecord
    #accessors provide a get and set function
  attr_accessor :remember_token
  
  #provides database constraints
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false } #true is implied with case sensitive
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string, secures a password
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token used as a key for remembering sessions 
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # remembers a user
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token)) #no password authentication?
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
   # Returns true if the given token matches the digest. Verifies that the user retrieved from the database is the correct user
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end