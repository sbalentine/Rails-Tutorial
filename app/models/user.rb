require 'digest'
class User < ActiveRecord::Base
  
  # attributes that can be changed
  
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  # regex for recognizing email patterns
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  # rule for presence and length
  
  validates :name,     :presence          => true, 
                       :length            => {:maximum => 50}
  
  # rule for presence, format, uniqueness, and case-sensitivity
  
  validates :email,    :presence          => true, 
                       :format            => {:with => email_regex},
                       :uniqueness        => {:case_sensitive => false}
                    
  # automatically create the virtual attribute 'password_confirmation'
  
  validates :password, :presence          => true,
                       :confirmation      => true,
                       :length            => {:within => 6..40}
  
  # encrypt passwords
                     
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_passord)
  end
  
  private
  
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
  
end
